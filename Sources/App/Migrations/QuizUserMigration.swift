//
//  QuizUserMigration.swift
//
//
//  Created by Moon Jongseek on 2022/07/22.
//

import FluentKit

struct QuizUserMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("quizStatus")
            .case(QuizStatus.right.rawValue)
            .case(QuizStatus.wrong.rawValue)
            .case(QuizStatus.done.rawValue)
            .create()
        
        return database.schema(QuizUser.schema)
            .id()
            .field("history", .array(of: .custom(QuizHistory.self)))
            .field("exp", .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(QuizUser.schema).delete()
    }
}

//@ID(key: .id)var id: UUID?
//@Field(key: "history")var history: [Quiz: QuizStatus]
//@Field(key: "exp")var exp: Int
