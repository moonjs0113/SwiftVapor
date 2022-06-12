//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/06/12.
//

import Fluent
import Vapor

struct StepController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let step = routes.grouped("step")
        step.get(use: self.allStep)
        step.post(use: self.getSingletep)
        step.group("register") { register in
            register.post(use: self.registerStep)
            register.delete(use: self.deleteStep)
        }
    }
    
    func allStep(req: Request) throws -> EventLoopFuture<[Step]> {
        return Step.query(on: req.db).sort(\.$currentStep).all()
    }
    
    func getSingletep(req: Request) throws -> EventLoopFuture<Step> {
//        let step = try req.content.decode(Step.self)
        guard let bodyData = req.body.data else {
            throw Abort(.badRequest, reason: "Require Body")
        }
        
        let step = try JSONDecoder().decode(RequestStep.self, from: bodyData)
        
        return Step.query(on: req.db)
            .filter(\.$courseID == step.courseID)
            .filter(\.$currentStep == step.currentStep)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func registerStep(req: Request) throws -> EventLoopFuture<Step> {
        let step = try req.content.decode(Step.self)
        return step.create(on: req.db).map { step }
    }
    
    func deleteStep(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let bodyData = req.body.data else {
            throw Abort(.badRequest, reason: "Require Body")
        }
        
        let step = try JSONDecoder().decode(RequestStep.self, from: bodyData)
        
        return Step.query(on: req.db)
            .filter(\.$id == step.id)
//            .filter(\.$courseID == step.courseID)
//            .filter(\.$currentStep == step.currentStep)
            .all()
            .flatMap{
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
//    func deleteStep(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Step.query(on: req.db)
//            .filter(\.$id == id)
//
//            .unwrap(or: Abort(.notFound))
//            .flatMap {
//                $0.delete(on: req.db)
//            }
//            .transform(to: .ok)
//    }
//    
//    func getCourseInfo(req: Request) throws -> EventLoopFuture<Course> {
//        guard let courseName = req.parameters.get("id") else {
//            throw Abort(.badRequest, reason: "Failed Get Parameters")
//        }
//        
//        return Course.query(on: req.db).filter(\.$courseName == courseName)
//            .first()
//            .unwrap(or: Abort(.badRequest, reason: "courseName: \(courseName) Not Found"))
//    }
    
    
}
