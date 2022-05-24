//
//  Task.swift
//  
//
//  Created by Moon Jongseek on 2022/05/24.
//

import Fluent
import Vapor

final class Task: Model, Content {
    static let schema: String = "tasks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Enum(key: "status")
    var status: Status
    
    @OptionalField(key: "comment")
    var comment: String?
    
    @Timestamp(key: "created_date", on: .create)
    var createdDate: Data?
    
    init() {
        
    }
    
    init(id: UUID? = nil, title: String, status: Status, comment: String? = nil, createdDate: Date? = nil) {
        self.id = id
        self.title = title
        self.status = status
        self.comment = comment
        self.createdDate = createdDate
    }
}

enum Status: String, Codable {
    case toDo, doing, done
}

extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("status", as: String.self, is: .in("toDo","doing","done"))
        validations.add("comment", as: String?.self, required: false)
    }
}
