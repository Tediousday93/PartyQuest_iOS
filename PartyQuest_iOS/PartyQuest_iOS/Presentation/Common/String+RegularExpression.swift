//
//  String+RegularExpression.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d@#$%^&+=]{8,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        return predicate.evaluate(with: self)
    }
    
    func isValidNickname() -> Bool {
        let nicknameRegex = "^[A-Za-z0-9]{2,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        
        return predicate.evaluate(with: self)
    }
}
