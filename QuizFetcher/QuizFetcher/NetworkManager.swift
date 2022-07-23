//
//  NetworkManager.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/24.
//

import Foundation

enum NetworkError: Error {
    case invaildURLString
    case invaildURL
    case invaildData
    case notJSONString
    case jsonDecoderError
    case nilResponse
}

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
}

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    let baseURLString: String = "http://ec2-3-237-49-198.compute-1.amazonaws.com/"
    
    func registerQuiz(quiz: Quiz) {
        guard let url = URL(string: baseURLString + "/quiz/register") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
        let quizDTO: QuizDTO = QuizDTO(quiz: quiz)
        request.httpBody = try? JSONEncoder().encode(quizDTO)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print(error)
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
}
