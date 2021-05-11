//
//  BCryptHasher.swift
//  ResortFeedback
//
//  Created by Robert Olieman on 4/23/21.
//

import Foundation
import BCrypt

class BCryptHasher {
    let numberOfRounds: Int
    private init(numberOfRounds: Int) {
        self.numberOfRounds = numberOfRounds
    }
    
    static var standard: BCryptHasher {
        return BCryptHasher(numberOfRounds: 12)
    }
    
    func hashPasword(_ password: String) throws -> String {
        let salt = try BCrypt.Salt(._2A, rounds: self.numberOfRounds)
        return try BCrypt.Hash(password, salt: salt)
    }
    
    func verify(_ password: String, matchesHash hash: String) -> Bool {
            return BCrypt.Check(password, hashed: hash)
    }
}


