//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/11.
//

import Fluent
import Vapor

struct RequestStep: Codable {
    var courseID: UUID
    var currentStep: Int
}

final class Step: Model, Content {
    static let schema: String = "step"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "courseID")
    var courseID: UUID
    
    @Field(key: "totalStep")
    var totalStep: Int
    
    @Field(key: "currentStep")
    var currentStep: Int
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    init() {
        
    }
    
    init(id: UUID? = nil, courseID: UUID, totalStep: Int, currentStep: Int, title: String, content: String) {
        self.id = id
        self.courseID = courseID
        self.totalStep = totalStep
        self.currentStep = currentStep
        self.title = title
        self.content = content
    }
}

