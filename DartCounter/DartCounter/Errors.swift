//
//  Errors.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.12.20.
//

import Foundation

class Errors {
    
    enum GeneralError: Error {
        case initError(String)
    }
    
    enum UserServiceError: Error {
        case userNilError(String)
    }
    
}

