//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/12.
//

import Foundation
import FluentKit
import FluentPostgresDriver

struct StepMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Step.schema)
            .id()
            .field("totalStep", .int, .required)
            .field("currentStep", .int, .required)
            .field("title", .string, .required)
            .field("content", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Step.schema).delete()
    }
}
