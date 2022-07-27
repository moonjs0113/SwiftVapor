//
//  main.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/22.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func requestJSONDataFromSheets() throws -> [Quiz] {
    print("[Info]: Try Fetch Sheet Data")
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

var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.dateFormat = "yyyyMMdd"
    return dateFormatter
}

func quizFetch() {
    // 1. 모든 문제를 가져온다.
    var allQuizList: [QuizDTO?] = []
    NetworkManager.shared.requestAllQuiz { allQuiz in
        print("[Info]: Request All Quiz")
        allQuizList = allQuiz
        do {
            let sheetQuiz = try requestJSONDataFromSheets()
            print("[Success]: Complete Load Sheet Data")
            if allQuiz.count < sheetQuiz.count {
                for i in allQuiz.count...sheetQuiz.count-1 {
                    print("Register New Quiz ID: \(i)")
                    NetworkManager.shared.registerQuiz(quiz: sheetQuiz[i])
                }
                NetworkManager.shared.requestAllQuiz { newAllQuiz in
                    print("Fetch New Quiz")
                    allQuizList = newAllQuiz
                    let notPublishedQuiz = allQuizList.filter { quiz in
                        if let quiz = quiz {
                            return !quiz.isPublished
                        }
                        return false
                    }
                    
                    if notPublishedQuiz.count < 3 { return }
                    NetworkManager.shared.deleteTodayQuiz()
                    
                    for todayQuiz in notPublishedQuiz[0...2] {
                        if let todayQuiz = todayQuiz {
                            NetworkManager.shared.registerTodayQuiz(quiz: todayQuiz)
                            NetworkManager.shared.updateTodayQuiz(quiz: todayQuiz)
                        }
                    }
                }
            } else {
                let notPublishedQuiz = allQuizList.filter { quiz in
                    if let quiz = quiz {
                        return !quiz.isPublished
                    }
                    return false
                }
                
                if notPublishedQuiz.count < 3 { return }
                
                NetworkManager.shared.deleteTodayQuiz()
                for todayQuiz in notPublishedQuiz[0...2] {
                    if let todayQuiz = todayQuiz {
                        NetworkManager.shared.registerTodayQuiz(quiz: todayQuiz)
                        NetworkManager.shared.updateTodayQuiz(quiz: todayQuiz)
                    }
                }
            }
            print("Replace Today Quiz")
        } catch(let e) {
            print("[Error]: Fail Get Sheet Data with \(e as? NetworkError)")
        }
        
    }
}

var SAVED_DATA_INT = -1

Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
    
    let nowDateInt = Int(dateFormatter.string(from: Date())) ?? 0
    print("[Info]: Current Date Value:  \(Date()) (value: \(nowDateInt))")
    print("[Info]: Save Date Value: \(SAVED_DATA_INT)")
    if nowDateInt > SAVED_DATA_INT {
        print("[Info]: Try Fetch")
        quizFetch()
        SAVED_DATA_INT = Int(dateFormatter.string(from: Date())) ?? -1
    }
}


while true {
    RunLoop.current.run(until: Date().addingTimeInterval(0.1))
}
