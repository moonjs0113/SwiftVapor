//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/08.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Movie: Model, Content {
    
    static let schema = "movies"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init() {}
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
    
}
