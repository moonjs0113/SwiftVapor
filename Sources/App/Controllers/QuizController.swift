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
//        quiz.get("todayQuiz", use: todayQuiz)
        quiz.get("allUser", use: allUser)
        quiz.group(":id") { quizUserID in
            quizUserID.delete(use: deleteUser)
        }
    }

//     get token v
    // get 문제 3개
    
    // get history
    // post 문제 결과
    
    
    // User
    func firstUserToken(req: Request) throws -> EventLoopFuture<QuizUser> {
        let quizUser = QuizUser(exp: 0)
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
        NetworkManager.fetchQuizList()
        return QuizUser.query(on: req.db).sort(\.$id).all()
    }
    
    // Today Quiz
//    func todayQuiz(req: Request) throws -> EventLoopFuture<Quiz> {
//        let quiz = try req.content.decode(Quiz.self)
//        return quiz.encodeResponse(for: req)
//    }
    

}

final class NetworkManager {
    static func fetchQuizList() {
        let urlString = "https://docs.google.com/spreadsheets/d/1hmXMCpAXUX33AoD8HxWS6BfeigGie9Y_GtJGaaxsIIg/edit#gid=938396143"
        
        guard let url = URL(string: urlString) else {
            print("invaild URL")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            print(data)
        } catch {
            print("Fail")
        }
    }
}
