//
//  QuizMigration.swift
//  
//
//  Created by Moon Jongseek on 2022/07/22.
//

import FluentKit

struct QuizMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("type")
            .case(QuizType.blank.rawValue)
            .case(QuizType.choice.rawValue)
            .create()
        
        return database.schema(Quiz.schema)
            .id()
            .field("type", .string, .required)
            .field("question", .string, .required)
            .field("rightAnswer", .string, .required)
            .field("wrongAnswer", .string, .required)
            .field("description", .string, .required)
            .field("example", .array(of: .string), .required)
            .field("isPublished", .bool, .required)
            .field("publishedDate", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Quiz.schema).delete()
    }
}

//@ID(key: .id) var id: UUID?
//@Field(key: "type") var type: QuizType
//@Field(key: "question") var question: String
//@Field(key: "rightAnswer") var rightAnswer: String
//@Field(key: "wrongAnswer") var wrongAnswer: String
//@Field(key: "description") var description: String
//@Field(key: "example") var example: [String]
//@Field(key: "isPublished") var isPublished: Bool
//@Field(key: "publishedDate") var publishedDate: Date?
