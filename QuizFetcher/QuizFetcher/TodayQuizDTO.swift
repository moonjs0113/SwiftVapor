//
//  TodayQuizDTO.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/25.
//

import Foundation

struct TodayQuiz: Codable {
    var quizID: Int
    var type: String
    var question: String
    var rightAnswer: String
    var wrongAnswer: String
    var description: String
    var example: [String]
    
//    var exmpleList: [String] {
//        return example.components(separatedBy: "\n")
//    }
    
    init(quiz: Quiz) {
        self.quizID = Int(quiz.quizID) ?? 0
        self.type = quiz.type
        self.question = quiz.question
        self.rightAnswer = quiz.rightAnswer
        self.wrongAnswer = quiz.wrongAnswer
        self.description = quiz.description
        self.example = quiz.exmpleList
    }
}
