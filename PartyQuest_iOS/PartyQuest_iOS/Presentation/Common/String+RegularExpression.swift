//
//  String+RegularExpression.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        // 대소문자 a~z/0~9/특문_ . % + - 가능, @ 기호 포함, 대소문자 a~z/0~9/특문 . 포함, - 가능, . 뒤에 2자이상 영문자
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluate(with: self)
    }
    
    // 특문 1자, 대문자 1자 포함, 소문자 1자이상, 숫자 1자 이상, 8~15자리, 허용 특문 @#$%^&+=!
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
    
    // 19/20 으로 시작, yyyy 년도 이후 mm이 01~12 까지 두자리숫자, dd 01~31까지 두자리 숫자
    func isValidBirthDate() -> Bool {
        let birthDateRegex = #"^(19|20)\d\d(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", birthDateRegex)
        
        return predicate.evaluate(with: self)
    }
}
