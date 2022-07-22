//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/10.
//

import Foundation
import FluentKit
import FluentPostgresDriver

struct CourseMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Course.schema)
            .id()
            .field("courseName", .string, .required)
            .field("totalStep", .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Course.schema).delete()
    }
}
