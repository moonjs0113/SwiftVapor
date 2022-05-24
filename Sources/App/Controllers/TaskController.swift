//
//  TaskController.swift
//  
//
//  Created by Moon Jongseek on 2022/05/24.
//

import Fluent
import Vapor

// Route가 그룹화할 수 있도록 RouteCollection 채택
struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")
        tasks.get(use: self.showAll) // GET /tasks
        tasks.post(use: self.create) // POST /tasks
        tasks.group(":id") { task in // :id - Dynamic Parameter
            tasks.delete(use: self.delete) // DELETE /tasks/:id
        }
    }
    
    // 조회
    func showAll(req: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: req.db).all()
    }
    
    // Request Body를 decoding 하여 DB에 저장
    // 반환값 EventLoopFuture은 비동기적으로 저장이 완료되었음을 알리는 것
    func create(req: Request) throws -> EventLoopFuture<Task> {
        try Task.validate(content: req)
        let task = try req.content.decode(Task.self)
        return task.create(on: req.db).map{ task }
    }
    
    // id로 데이터 조회, 없으면 unwrap이 호출 되며 .notFound 오류 반환
    // flatMap 콜백으로 EventLoopFuture 반환 -> 중첩을 피하기 위하
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Task.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
}

