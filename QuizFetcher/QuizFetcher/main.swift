//
//  main.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/22.
//

import Foundation

func requestJSONDataFromSheets() async throws -> [Quiz] {
    let urlString = "https://docs.google.com/spreadsheets/d/1YSAsmsb0b3fSXBrPGS8c6Pg15LtgxtvTm9gcNVlESLo/gviz/tq?gid=938396143"
    guard let url = URL(string: urlString) else {
        throw NetworkError.invaildURLString
    }
    
    guard let dataString = try? String(contentsOf: url).components(separatedBy: "\n")[1] else {
        throw NetworkError.invaildURL
    }
    
    guard let startIndex = dataString.firstIndex(of: "("),
          let lastIndex = dataString.lastIndex(of: ")") else {
        throw NetworkError.notJSONString
        
    }
    
    guard let data = dataString[startIndex...lastIndex].dropFirst().dropLast().data(using: .utf8) else {
        throw NetworkError.invaildData
    }
    
    guard let sheet = try? JSONDecoder().decode(Sheet.self, from: data) else {
        throw NetworkError.jsonDecoderError
    }
    
    var quizList: [Quiz] = []
    
    for row in sheet.table.rows {
        let quiz = createQuiz(rowValue: row.c)
        quizList.append(quiz)
    }
    
    return quizList
}

func createQuiz(rowValue: [RowValue?]) -> Quiz {
    return Quiz(quizID: rowValue[0]?.v ?? "",
                type: rowValue[1]?.v ?? "",
                question: rowValue[3]?.v ?? "",
                rightAnswer: rowValue[4]?.v ?? "",
                wrongAnswer: rowValue[5]?.v ?? "",
                description: rowValue[6]?.v ?? "",
                example: rowValue[7]?.v ?? "")
}

Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
    Task(priority: .high) {
        do {
            // 1. 모든 문제를 가져온다.
            var allQuiz = try await NetworkManager.shared.requestAllQuiz()
             print("first All Quiz: \(allQuiz)")
            // 2. 시트 문제를 가져온다.
            let sheetQuiz = try await requestJSONDataFromSheets()

            // 3. 시트 문제랑 비교해서
            
            print(allQuiz.count, sheetQuiz.count)
            
            if allQuiz.count < sheetQuiz.count {
                for i in allQuiz.count...sheetQuiz.count-1 {
                    // 3-1. 새로운 문제를 서버에 업로드한다.
                    try await NetworkManager.shared.registerQuiz(quiz: sheetQuiz[i])
                }
                // 3-2. 모든 문제를 업데이트한다.
                allQuiz = try await NetworkManager.shared.requestAllQuiz()
            }
            
            print("4. 어제의 퀴즈를 가져온다.")
            // 4. 어제의 퀴즈를 가져온다.
            let yesterDayQuiz = try await NetworkManager.shared.requestTodayQuiz()
            print(yesterDayQuiz)
            
            // MARK: - Current
            
            // 5. 어제 문제를 User history에 추가
//            for quiz in yesterDayQuiz {
//                try await NetworkManager.shared.updateUserHistory(quiz: quiz)
//            }
            
            // 6-1. 출제가 안된 문제들
            
            let notPublishedQuiz = allQuiz.filter { quiz in
                print(quiz.isPublished)
                return !quiz.isPublished
            }
            
            print(notPublishedQuiz.count)
            
            // 6-2. 3문제 이상이 안 되면 에러
            if notPublishedQuiz.count < 3 {
                throw NetworkError.notEnoughQuiz
            }

            // 7. 기존 오늘의 문제 삭제
            try await NetworkManager.shared.deleteTodayQuiz()
            
            for todayQuiz in notPublishedQuiz[0...2] {
//                 8. 오늘의 문제 등록
                print(todayQuiz)
                try await NetworkManager.shared.registerTodayQuiz(quiz: todayQuiz)

//                 9. Quiz 테이블에 isPublished 업데이트
                try await NetworkManager.shared.updateTodayQuiz(quiz: todayQuiz)
            }
            print("Finish!")
        } catch(let e as NetworkError) {
            print(e)
        }
    }
}

while true {
    RunLoop.current.run(until: Date().addingTimeInterval(0.1))
}
