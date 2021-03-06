//
//  QuizUser.swift
//  
//
//  Created by Moon Jongseek on 2022/07/22.
//

import Fluent
import Vapor

enum QuizStatus: String, Codable {
    case right
    case wrong
    case done
}

struct SolveQuiz: Codable {
    var quizID: UUID
    var userID: UUID
    var answer: String
}

struct UserHistory: Codable {
    var userID: UUID
}

struct QuizHistory: Codable {
    var quiz: Quiz
    var quizStatus: QuizStatus
}

final class QuizUser: Model, Content {
    static let schema = "quizUser"
    
    /// QuizUser의 ID
    @ID(key: .id)
    var id: UUID?
    
    /// QuizUser의 History
    @Field(key: "history")
    var history: [QuizHistory]
    
    /// QuizUser의 Exp
    @Field(key: "exp")
    var exp: Int
    
    init() {
        
    }

    init(id: UUID? = nil, history: [QuizHistory] = [], exp: Int = 0) {
        self.id = id
        self.history = history
        self.exp = exp
    }
}
