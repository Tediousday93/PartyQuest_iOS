//
//  ShadowDecorationView.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/21.
//

import UIKit

final class ShadowDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = PQColor.lightGray
        layer.masksToBounds = false
        layer.shadowColor = PQColor.shadow
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1
        layer.cornerRadius = 10
    }
}
