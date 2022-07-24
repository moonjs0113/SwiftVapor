//
//  QuizDTO.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/24.
//

import Foundation

struct QuizDTO: Codable {
    var quizID: String
    var type: String
    var question: String
    var rightAnswer: String
    var wrongAnswer: String
    var description: String
    var example: [String]
    
//    var exmpleList: [String] {
//        return example.components(separatedBy: "\n")
//    }
    
    var isPublished: Bool = false
    
    init(quiz: Quiz) {
        self.quizID = quiz.quizID
        self.type = quiz.type
        self.question = quiz.question
        self.rightAnswer = quiz.rightAnswer
        self.wrongAnswer = quiz.wrongAnswer
        self.description = quiz.description
        self.example = quiz.exmpleList
    }
}
