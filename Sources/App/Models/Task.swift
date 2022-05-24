//
//  Task.swift
//  
//
//  Created by Moon Jongseek on 2022/05/24.
//

import Fluent
import Vapor

final class Task: Model, Content {
    // DB Table or Collection Name
    static let schema: String = "tasks"
    
    // Model Primary Key
    @ID(key: .id)
    var id: UUID?
    
    // key: DB Key
    // 프로퍼티 이름이랑 Key랑 달라도 된다.
    // Codable 준수
    @Field(key: "title")
    var title: String
    
    // @Field의 한 종류
    // DB 열거형으로 저장
    // Enum이 Optional일 땐, OptionalEnum를 쓴다.
    @Enum(key: "status")
    var status: Status
    
    // Field가 Optional일 때 쓴다.
    @OptionalField(key: "comment")
    var comment: String?
    
    // @Field의 한 종류, 설정한 트리거(on:)에 따라 Fluent가 자동으로 설정
    @Timestamp(key: "created_date", on: .create)
    var createdDate: Date?
    
    // Fluent가 Query에 의해 모델을 생성할 때 사용
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
