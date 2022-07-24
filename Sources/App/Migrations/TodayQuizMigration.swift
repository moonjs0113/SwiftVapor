//
//  TodayQuizMigration.swift
//  
//
//  Created by Moon Jongseek on 2022/07/24.
//

import FluentKit

struct TodayQuizMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        _ = database.enum("type")
//            .case(QuizType.blank.rawValue)
//            .case(QuizType.choice.rawValue)
//            .create()
        
        return database.schema(Quiz.schema)
            .id()
            .field("quizID", .int, .required)
            .field("type", .string, .required)
            .field("question", .string, .required)
            .field("rightAnswer", .string, .required)
            .field("wrongAnswer", .string, .required)
            .field("description", .string, .required)
            .field("example", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(TodayQuiz.schema).delete()
    }
}
