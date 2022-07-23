//
//  SheetModel.swift
//  QuizFetcher
//
//  Created by Moon Jongseek on 2022/07/24.
//

import Foundation

struct Sheet: Codable {
    let version: String
    let reqId: String
    let status: String
    let sig: String
    let table: SheetTable
}

struct SheetTable: Codable {
    var cols: [Column]
    var rows: [Row]
    var parsedNumHeaders: Int
}

struct Column: Codable {
    let id: String
    let label: String
    let type: String
//    let pattern: String?
}

struct Row: Codable {
    var c: [RowValue?]
}

struct RowValue: Codable {
    var v: String?
//    var f: String?
}

struct Quiz {
    var quizID: String
    var type: String
    var question: String
    var rightAnswer: String
    var wrongAnswer: String
    var description: String
    var example: String
    
    var exmpleList: [String] {
        return example.components(separatedBy: "\n")
    }
//    var isPublished: Bool
//    var publishedDate: Date?
}
