//
//  TaskMigration.swift
//  
//
//  Created by Moon Jongseek on 2022/05/24.
//

import Fluent

struct TaskMigration: Migration {
    // DB에 테이블, 필드, 제약 등을 추가/삭제
    // 모델 인스턴스 생성, 필드값 업데이트 등 데이터 수정 수행
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("status")  // Native DB Enum 생성
            .case("toDo")
            .case("doing")
            .case("done")
            .create()
        
        return database.enum("status").read() // 데이터 타입으로 사용
            .flatMap { status in
            database.schema(Task.schema) // SchemaBuilder 생성
                .id()
                .field("title", .string, .required) // 필드 추가(이름,데이터타입,제약)
                .field("status", status, .required)
                .field("comment", .string)
                .field("created_date", .datetime, .required)
                .create() // Table or Collection 생성
        }
    }
    
    // prepare 변화를 되돌림
    // 테스트
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
    }
    
}

