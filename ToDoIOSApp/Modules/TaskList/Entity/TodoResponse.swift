//
//  TodoResponse.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 02.06.2025.
//

import Foundation

// MARK: - TodoResponse

struct TodoResponse: Codable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - TodoDTO

struct TodoDTO: Codable {
    let id: Int64
    let todo: String
    let completed: Bool
    let userId: Int64
}

