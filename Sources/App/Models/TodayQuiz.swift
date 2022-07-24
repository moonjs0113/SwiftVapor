//
//  TodayQuiz.swift
//  linux0
//
//  Created by Moon Jongseek on 2022/07/24.
//

import Fluent
import Vapor

final class TodayQuiz: Model, Content {
    static let schema = "todayquiz"
    
    /// Quiz의 DB ID
    @ID(key: .id)
    var id: UUID?
    
    /// Quiz Sheet ID
    @Field(key: "quizID")
    var quizID: Int
    
    /// 문제의 유형
    @Enum(key: "type")
    var type: QuizType
    
    /// 문제
    @Field(key: "question")
    var question: String
    
    /// 문제 정답
    @Field(key: "rightAnswer")
    var rightAnswer: String
    
    /// 문제 오답
    @Field(key: "wrongAnswer")
    var wrongAnswer: String
    
    /// 문제 해설
    @Field(key: "description")
    var description: String
    
    /// 문제 예시
    @Field(key: "example")
    var example: [String]
    
    init() {
        
    }
    
    init(id: UUID? = nil, quizID: Int, type: QuizType, question: String,
         rightAnswer: String, wrongAnswer: String, description: String,
         example: [String]) {
        self.id = id
        self.quizID = quizID
        self.type = type
        self.question = question
        self.rightAnswer = rightAnswer
        self.wrongAnswer = wrongAnswer
        self.description = description
        self.example = example
    }
}

