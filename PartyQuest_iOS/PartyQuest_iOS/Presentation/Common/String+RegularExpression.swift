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
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d@#$%^&+=!]{8,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        return predicate.evaluate(with: self)
    }
    
    func isValidNickname() -> Bool {
        let nicknameRegex = "^[A-Za-z0-9]{2,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        
        return predicate.evaluate(with: self)
    }
    
    func isValidBirthDate() -> Bool {
        let birthDateRegex = #"^(19|20)\d\d(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", birthDateRegex)
        
        return predicate.evaluate(with: self)
    }
}
