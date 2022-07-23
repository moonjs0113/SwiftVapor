//
//  main.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/22.
//

import Foundation

func requestJSONDataFromSheets() async throws -> Sheet {
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
    
    return sheet
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

Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    Task(priority: .high) {
        do {
            let sheet = try await requestJSONDataFromSheets()
            for row in sheet.table.rows {
                let quiz = createQuiz(rowValue: row.c)
                print(quiz)
            }
        } catch(let e as NetworkError) {
            print(e)
        }
    }
}

while true {
    RunLoop.current.run(until: Date().addingTimeInterval(0.1))
}

