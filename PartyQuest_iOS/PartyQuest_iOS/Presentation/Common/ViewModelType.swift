//
//  ViewModelType.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/01.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
