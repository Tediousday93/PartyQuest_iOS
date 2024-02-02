//
//  AddQuestTitleView.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/02.
//

import UIKit

final class AddQuestTitleView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 퀘스트"
        label.font = PQFont.basicBold
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.isEnabled = false
        
        return button
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubViews() {
        titleStackView.addArrangedSubview(closeButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(addButton)
        
        addSubview(titleStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: self.topAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
}
