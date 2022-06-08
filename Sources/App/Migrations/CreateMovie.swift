//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/08.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateMovie: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("movies")
            .id()
            .field("title", .string)
            .create()
        
    }
    
    // undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies").delete()
    }
    
}
