//
//  AuthentificationService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

protocol AuthentificationService {
    func requestLogIn(email: String, password: String)
    func requestSignUp(email: String, password: String, nickname: String, birth: String)
}
