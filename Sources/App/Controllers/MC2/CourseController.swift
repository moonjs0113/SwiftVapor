//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/10.
//

import Fluent
import Vapor

struct CourseController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let course = routes.grouped("course")
        course.get(use: self.allCourse)
        course.post(use: self.createCourse)
        course.group(":id") { courseID in
            courseID.delete(use: self.delete)
            courseID.get(use: self.getCourseInfo)
        }
    }
    
    func allCourse(req: Request) throws -> EventLoopFuture<[Course]> {
        return Course.query(on: req.db).all()
    }
    
    func createCourse(req: Request) throws -> EventLoopFuture<Course> {
        let course = try req.content.decode(Course.self)
        return course.create(on: req.db).map { course }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Course.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
    func getCourseInfo(req: Request) throws -> EventLoopFuture<Course> {
        guard let courseName = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Failed Get Parameters")
        }
        
        return Course.query(on: req.db).filter(\.$courseName == courseName)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "courseName: \(courseName) Not Found"))
    }
    
    
}
