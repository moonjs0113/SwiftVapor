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
        // External Response
        quiz.get("firstUserToken", use: firstUserToken)
        quiz.get("todayQuiz", use: todayQuiz)
//        quiz.post("submitAnswer", use: solveResult)
        //        quiz.post("history", use: history)
        
        
        // Internal Response
        // Quiz
        quiz.get("allQuiz", use: allQuiz)
        quiz.post("register", use: registerQuiz)
        quiz.delete(use: deleteAllQuiz)
        quiz.group(":id") { quizID in
            quizID.get(use: singleQuiz)
            quizID.delete(use: deleteQuiz)
        }
        
        // TodayQuiz
        quiz.delete("todayQuiz", use: deleteAllTodayQuiz)
        quiz.post("registerTodayQuiz", use: registerTodayQuiz)
        quiz.post("updateTodayQuiz", use: updateTodayQuiz)
        
        
        // Quiz User
        let quizUser = routes.grouped("quizUser")
        quizUser.get("allUser", use: allUser)
//        quizUser.post("updateUserHistory", use: updateUserHistory)
        quizUser.group(":id") { quizUserID in
            quizUserID.get(use: singleUser)
            quizUserID.delete(use: deleteUser)
        }
    }
    
    // MARK: - USER
    // User
    func deleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return QuizUser.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
    func singleUser(req: Request) throws -> EventLoopFuture<QuizUser> {
        guard let quizUserUUIDString = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Failed Get Parameters")
        }
        
        guard let quizUserID = UUID(uuidString: quizUserUUIDString) else {
            throw Abort(.badRequest, reason: "Invaild UUID String")
        }
        
        return QuizUser.query(on: req.db)
            .filter(\.$id == quizUserID)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func allUser(req: Request) throws -> EventLoopFuture<[QuizUser]> {
        return QuizUser.query(on: req.db).sort(\.$id).all()
    }
    
    // updateUserHistory 수정
//    func updateUserHistory(req: Request) throws -> EventLoopFuture<[QuizUser]> {
//        guard let bodyData = req.body.data else {
//            throw Abort(.badRequest, reason: "Require Body")
//        }
//
//        let quizUser = try JSONDecoder().decode(Quiz.self, from: bodyData)
//
//        return QuizUser.query(on: req.db).sort(\.$id).all()
//    }
    
    // MARK: - QUIZ
    // Create
    func registerQuiz(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let quiz = try req.content.decode(Quiz.self)
        return quiz.create(on: req.db)
            .map { $0 }
            .transform(to: .ok)
    }
    
    // Read
    func singleQuiz(req: Request) throws -> EventLoopFuture<Quiz> {
        return Quiz.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func allQuiz(req: Request) throws -> EventLoopFuture<[Quiz]> {
        return Quiz.query(on: req.db).sort(\.$quizID).all()
    }
    
    // Update
    
    // Delete
    func deleteAllQuiz(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Quiz.query(on: req.db)
            .all()
            .mapEach { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func deleteQuiz(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Quiz.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.custom(code: 404, reasonPhrase: "UUID Not Found")))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    // MARK: - Today Quiz
    func registerTodayQuiz(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let quiz = try req.content.decode(TodayQuiz.self)
        return quiz.create(on: req.db)
            .map { quiz }
            .transform(to: .ok)
    }
    
    func updateTodayQuiz(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let quiz = try req.content.decode(TodayQuiz.self)
        return Quiz.query(on: req.db)
            .filter(\.$quizID == quiz.quizID)
            .all()
            .mapEach {
                $0.publishedDate = Date()
                $0.isPublished = true
                $0.update(on: req.db)
            }
            .transform(to: .ok)
        
    }
    
    func deleteAllTodayQuiz(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return TodayQuiz.query(on: req.db)
            .all()
            .mapEach { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    // MARK: - Function
    func firstUserToken(req: Request) throws -> EventLoopFuture<QuizUser> {
        let quizUser = QuizUser(exp: 0)
        return quizUser.create(on: req.db)
            .map{ quizUser }
    }
    
    func todayQuiz(req: Request) throws -> EventLoopFuture<[TodayQuiz]> {
        return TodayQuiz.query(on: req.db)
            .sort(\.$quizID)
            .all()
    }
    
    func solveResult(req: Request) throws -> EventLoopFuture<Int> {
        guard let bodyData = req.body.data else {
            throw Abort(.badRequest, reason: "Require Body")
        }

        let solveQuiz = try JSONDecoder().decode(SolveQuiz.self, from: bodyData)
        var exp = 0
        return Quiz.query(on: req.db)
            .filter(\.$quizID == solveQuiz.quizID)
            .all()
            .mapEach { quiz in
                exp = (quiz.rightAnswer == solveQuiz.answer) ? 20 : 10
                if let publishedDate = quiz.publishedDate {
                    if publishedDate < Date.now {
                        exp -= 5
                    }
                }
                QuizUser.query(on: req.db)
                    .filter(\.$id == solveQuiz.userID)
                    .all()
                    .mapEach {
                        $0.exp += exp
                        $0.update(on: req.db)
                    }
            }
            .transform(to: exp)
    }
    
//    func history(req: Request) throws -> EventLoopFuture<[QuizHistory]> {
//        guard let bodyData = req.body.data else {
//            throw Abort(.badRequest, reason: "Require Body")
//        }
//
//        let quizUserID = try JSONDecoder().decode(UserHistory.self, from: bodyData)
//
//        return QuizUser.query(on: req.db)
//            .filter(\.$id == quizUserID.userID)
//            .first()
//            .unwrap(or: Abort(.notFound))
//            .map { $0.history }
//    }
}
