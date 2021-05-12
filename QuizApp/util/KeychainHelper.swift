//
//  KeychainHelper.swift
//  ResortFeedback
//
//  Created by Robert Olieman on 4/24/21.
//

import Foundation
import KeychainAccess

class KeychainHelper {
    private(set) var service = "QuizApp"
    
    struct Key {
        static let password = "password"
        static let username = "username"
        static let shouldSaveLoginCredentials = "shouldSaveLoginCredentials"
    }
 
    private let keychain: Keychain
    
    private var shouldSaveLoginCredentials: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.shouldSaveLoginCredentials)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: Key.shouldSaveLoginCredentials)
        }
    }
    
    init() {
        self.keychain = Keychain(service: service).accessibility(.whenUnlocked)
        if !self.shouldSaveLoginCredentials {
            self.deleteLoginCredentials()
        }
    }
    
    func saveLoginCredentials(_ loginCredentials: LoginCredentials) {
        self.shouldSaveLoginCredentials = true
        self.keychain[Key.username] = loginCredentials.username
        self.keychain[Key.password] = loginCredentials.password
    }
    
    func retrieveLoginCredentials() -> LoginCredentials? {
        guard let password = self.keychain[Key.password] else { return nil }
        guard let username = self.keychain[Key.username] else { return nil }
        return LoginCredentials(username: username, password: password)
    }
    
    func deleteLoginCredentials() {
        self.shouldSaveLoginCredentials = false
        self.keychain[Key.password] = nil
        self.keychain[Key.username] = nil
    }
    
}
