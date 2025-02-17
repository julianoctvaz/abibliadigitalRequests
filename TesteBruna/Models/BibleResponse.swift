//
//  BibleResponse.swift
//  TesteBruna
//
//  Created by Juliano on 10/02/25.
//

struct BibleResponse: Codable {
    let book: Book
    let chapter: Int
    let number: Int
    let text: String
}

struct Book: Codable {
    let abbrev: Abbreviation
    let name: String
    let author: String
    let group: String
    let version: String
}

struct Abbreviation: Codable {
    let pt: String
    let en: String
}
