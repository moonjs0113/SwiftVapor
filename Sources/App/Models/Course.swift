//
//  Course.swift
//  
//
//  Created by Moon Jongseek on 2022/06/10.
//

import Fluent
import Vapor

final class Course: Model, Content {
    static let schema: String = "course"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "courseName")
    var courseName: String
    
    @Field(key: "totalStep")
    var totalStep: Int
    
    init() {
        
    }
    
    init(id: UUID? = nil, courseName: String, totalStep: Int) {
        self.id = id
        self.courseName = courseName
        self.totalStep = totalStep
    }
}
