//
//  UserController.swift
//  RandomizingTableViewCodeChallenge
//
//  Created by Ethan Archibald on 2/28/24.
//

import Foundation

class UserController {
    
    static var shared = UserController()
    
    private var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveUsers(_ users: [User]) {
        let archiveURL = documentDirectory.appendingPathExtension("users").appendingPathExtension("json")
        let encoder = JSONEncoder()
        let encode = try? encoder.encode(users)
        try? encode?.write(to: archiveURL)
    }
    
    func loadUsers() -> [User] {
        let archiveURL = documentDirectory.appendingPathExtension("users").appendingPathExtension("json")
        let propertyListDecoder = JSONDecoder()
        if let retrivedData = try? Data(contentsOf: archiveURL),
            let decoded = try? propertyListDecoder.decode([User].self, from: retrivedData) {
            return decoded
        }
        return []
    }
}
