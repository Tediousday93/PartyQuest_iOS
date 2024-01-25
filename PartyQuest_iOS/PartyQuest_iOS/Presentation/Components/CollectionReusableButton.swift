//
//  ButtonFooterView.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/01.
//

import UIKit

final class CollectionReusableButton: UICollectionReusableView {
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = PQFont.basicBold
        button.titleLabel?.tintColor = PQColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonTitle(string title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setButtonTitleStyle(size: CGFloat, weight: UIFont.Weight) {
        button.titleLabel?.font = .systemFont(ofSize: size, weight: weight)
    }
    
    func setButtonColor(for color: UIColor) {
        button.backgroundColor = color
    }
    
    private func setSubviews() {
        addSubview(button)
    }
    
    private func setConstraints() {
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: safe.topAnchor),
            button.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
