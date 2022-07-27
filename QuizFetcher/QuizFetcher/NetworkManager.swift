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

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    let baseURLString: String = "http://127.0.0.1:8080"
    //"http://ec2-3-237-49-198.compute-1.amazonaws.com"
    
    // MARK: - Quiz
    func requestAllQuiz(complete: @escaping ([QuizDTO]) -> ()) {
        guard let url = URL(string: baseURLString + "/quiz/allQuiz") else {
            print("[Error]: \(NetworkError.invaildURL) \(#function)")
            return
//            throw NetworkError.invaildURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let quizDTOLiSt = try? JSONDecoder().decode([QuizDTO].self, from: data) {
                    complete(quizDTOLiSt)
                } else {
                    print("[Error]: \(NetworkError.jsonDecoderError) \(#function)")
                }
            } else {
                print("[Error]: \(NetworkError.nilResponse) \(#function)")
            }
        }
        .resume()
    }
    
    func registerQuiz(quiz: Quiz) {
        guard let url = URL(string: baseURLString + "/quiz/register") else {
            print("[Error]: \(NetworkError.invaildURL)")
//            throw NetworkError.invaildURL
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quizDTO)
        } catch {
            print("[Error]: \(NetworkError.jsonEncoderError) \(#function)")
//            throw NetworkError.jsonEncoderError
            return
        }
        URLSession.shared.dataTask(with: request).resume()
//        do {
//            let (_, _) = try await URLSession.shared.data(for: request)
//        } catch { throw NetworkError.requestError }
    }
    
    func requestNotPublishedQuiz(completeHandler: @escaping ([QuizDTO]) -> ()) {
        guard let url = URL(string: baseURLString + "/quiz/allQuiz") else {
            print("[Error]: \(NetworkError.invaildURL) \(#function)")
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
            print("[Error]: \(NetworkError.invaildURL)")
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
//    func requestTodayQuiz() async throws -> [TodayQuiz] {
//        guard let url = URL(string: baseURLString + "/quiz/todayQuiz") else {
//            throw NetworkError.invaildURL
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.GET.rawValue
//
//        let (data, _) = try await URLSession.shared.data(for: request)
//        do {
//            return try JSONDecoder().decode([TodayQuiz].self, from: data)
//        } catch {
//            throw NetworkError.jsonDecoderError
//        }
//    }
    
    func registerTodayQuiz(quiz: QuizDTO) {
        guard let url = URL(string: baseURLString + "/quiz/registerTodayQuiz") else {
            print("[Error]: \(NetworkError.invaildURL) \(#function)")
//            throw NetworkError.invaildURL
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
//        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quiz)
        } catch {
            print("[Error]: \(NetworkError.jsonEncoderError) \(#function)")
//            throw NetworkError.jsonEncoderError
            return
        }
        URLSession.shared.dataTask(with: request).resume()
//        do {
//            let (_, _) = try await URLSession.shared.data(for: request)
//        } catch { throw NetworkError.requestError }
    }
    
    func updateTodayQuiz(quiz: QuizDTO){
        guard let url = URL(string: baseURLString + "/quiz/updateTodayQuiz") else {
            print("[Error]: \(NetworkError.invaildURL) \(#function)")
//            throw NetworkError.invaildURL
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
//        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        do {
            request.httpBody = try JSONEncoder().encode(quiz)
        } catch {
            print("[Error]: \(NetworkError.jsonEncoderError) \(#function)")
//            throw NetworkError.jsonEncoderError
            return
        }
        
        URLSession.shared.dataTask(with: request).resume()
        
//        do {
//            let (_, _) = try await URLSession.shared.data(for: request)
//        } catch { throw NetworkError.requestError }
    }
    
    func deleteTodayQuiz() { // async throws {
        guard let url = URL(string: baseURLString + "/quiz/todayQuiz") else {
            print("[Error]: \(NetworkError.invaildURL) \(#function)")
//            throw NetworkError.invaildURL
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.DELETE.rawValue
        
        URLSession.shared.dataTask(with: request).resume()
//        do {
//            let (_, _) = try await URLSession.shared.data(for: request)
//        } catch { throw NetworkError.requestError }
    }
    
//    func updateUserHistory(quiz: QuizDTO) async throws {
//        guard let url = URL(string: baseURLString + "/quiz/updateUserHistory") else {
//            throw NetworkError.invaildURL
//        }
    
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.POST.rawValue
//
//        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
//        do {
//            request.httpBody = try JSONEncoder().encode(quiz)
//        } catch {
//            throw NetworkError.jsonEncoderError
//        }
//        do {
//            let (_, _): (Data, URLResponse) = try await URLSession.shared.data(for: request)
//        } catch { throw NetworkError.requestError }
//    }
}
