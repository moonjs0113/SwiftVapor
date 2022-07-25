//
//  NetworkManager.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/24.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum NetworkError: Error {
    case invaildURLString
    case invaildURL
    case invaildData
    case notJSONString
    case requestError
    case jsonDecoderError
    case jsonEncoderError
    case notEnoughQuiz
    case nilResponse
}

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
}

actor NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    let baseURLString: String = "http://ec2-3-237-49-198.compute-1.amazonaws.com"
    
    // MARK: - Quiz
    func requestAllQuiz() async throws -> [QuizDTO] {
        guard let url = URL(string: baseURLString + "/quiz/allQuiz") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([QuizDTO].self, from: data)
    }
    
    func registerQuiz(quiz: Quiz) async throws {
        guard let url = URL(string: baseURLString + "/quiz/register") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quizDTO)
        } catch {
            throw NetworkError.jsonEncoderError
        }
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch { throw NetworkError.requestError }
    }
    
    func requestNotPublishedQuiz(completeHandler: @escaping ([QuizDTO]) -> ()) {
        guard let url = URL(string: baseURLString + "/quiz/allQuiz") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
            } else if let data = data {
                if let quizDTOList = try? JSONDecoder().decode([QuizDTO].self, from: data) {
                    completeHandler(quizDTOList)
                }
            }
        }.resume()
    }
    
    func deleteAllQuiz(quiz: Quiz) {
        guard let url = URL(string: baseURLString + "/quiz") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.DELETE.rawValue
        
        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        request.httpBody = try? JSONEncoder().encode(quizDTO)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print(error)
            }
        }.resume()
    }
    
    // MARK: - Today Quiz
    func requestTodayQuiz() async throws -> [TodayQuiz] {
        guard let url = URL(string: baseURLString + "/quiz/todayQuiz") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            return try JSONDecoder().decode([TodayQuiz].self, from: data)
        } catch {
            throw NetworkError.jsonDecoderError
        }
    }
    
    func registerTodayQuiz(quiz: QuizDTO) async throws {
        guard let url = URL(string: baseURLString + "/quiz/registerTodayQuiz") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
//        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quiz)
        } catch {
            throw NetworkError.jsonEncoderError
        }
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch { throw NetworkError.requestError }
    }
    
    func updateTodayQuiz(quiz: QuizDTO) async throws {
        guard let url = URL(string: baseURLString + "/quiz/updateTodayQuiz") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
//        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quiz)
        } catch {
            throw NetworkError.jsonEncoderError
        }
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch { throw NetworkError.requestError }
    }
    
    func deleteTodayQuiz() async throws {
        guard let url = URL(string: baseURLString + "/quiz/todayQuiz") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.DELETE.rawValue
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch { throw NetworkError.requestError }
    }
    
    func updateUserHistory(quiz: QuizDTO) async throws {
        guard let url = URL(string: baseURLString + "/quiz/updateUserHistory") else {
            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
//        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quiz)
        } catch {
            throw NetworkError.jsonEncoderError
        }
        do {
            let (_, _): (Data, URLResponse) = try await URLSession.shared.data(for: request)
        } catch { throw NetworkError.requestError }
    }
}
