//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/07/22.
//

import Fluent
import Vapor
import Foundation

struct QuizController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let quiz = routes.grouped("quiz")
        quiz.get("firstUserToken", use: firstUserToken)
        quiz.get("allUser", use: allUser)
        quiz.group(":id") { quizUserID in
            quizUserID.delete(use: self.deleteUser)
        }
    }

    // get token
    // get 문제 3개
    
    // get history
    // post 문제 결과
    
    
    // 조회
    func firstUserToken(req: Request) throws -> EventLoopFuture<QuizUser> {
        let quizUser = QuizUser(exp: 0)
//        let quizUser = try req.content.decode(QuizUser.self)
//        return quizUser.encodeResponse(for: req)
        return quizUser.create(on: req.db).map{ quizUser }
    }
    
    func deleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return QuizUser.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }

    func allUser(req: Request) throws -> EventLoopFuture<[QuizUser]> {
        return QuizUser.query(on: req.db).sort(\.$id).all()
    }
}
