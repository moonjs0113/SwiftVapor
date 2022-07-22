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
        let todos = routes.grouped("quiz")
        todos.get("firstUserToken", use: firstUserToken)
    }

    // get token
    // get 문제 3개
    
    // get history
    // post 문제 결과
    
    
    // 조회
    func firstUserToken(req: Request) throws -> EventLoopFuture<Response> {
        let quizUser = QuizUser(exp: 0)
        return quizUser.encodeResponse(for: req)
    }

}
