//
//  Quiz.swift
//  
//
//  Created by Moon Jongseek on 2022/07/22.
//
import Fluent
import Vapor

enum QuizType: String, Codable {
    case blank // 유형 1
    case choice // 유형 2
}

final class Quiz: Model, Content, Hashable {
    static func == (lhs: Quiz, rhs: Quiz) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let schema = "quiz"
    
    /// Quiz의 DB ID
    @ID(key: .id)
    var id: UUID?
    
    /// Quiz Sheet ID
    @Field(key: "type")
    var quizID: QuizType
    
    /// 문제의 유형
    @Field(key: "type")
    var type: QuizType
    
    /// 문제
    @Field(key: "question")
    var question: String
    
    /// 문제 정답
    @Field(key: "rightAnswer")
    var rightAnswer: String
    
    /// 문제 오답
    @Field(key: "wrongAnswer")
    var wrongAnswer: String
    
    /// 문제 해설
    @Field(key: "description")
    var description: String
    
    /// 문제 예시
    @Field(key: "example")
    var example: [String]
    
    /// 출제 유무
    @Field(key: "isPublished")
    var isPublished: Bool
    
    /// 출제 날짜
    @OptionalField(key: "publishedDate")
    var publishedDate: Date?
    
    init() {
        
    }
    
    init(id: UUID? = nil, type: QuizType, question: String,
         rightAnswer: String, wrongAnswer: String, description: String,
         example: [String], isPublished: Bool, publishedDate: Date? = nil) {
        self.id = id
        self.type = type
        self.question = question
        self.rightAnswer = rightAnswer
        self.wrongAnswer = wrongAnswer
        self.description = description
        self.example = example
        self.isPublished = isPublished
        self.publishedDate = publishedDate
    }
}
