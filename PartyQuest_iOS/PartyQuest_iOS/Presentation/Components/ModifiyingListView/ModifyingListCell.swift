//
//  ModifyingListCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/02.
//

import UIKit

final class ModifyingListCell: UICollectionViewListCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.small
        label.textColor = UIColor.systemGray
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.textColor = .black
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let modifyButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "수정"
        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(.font,
                           value: UIFont.boldSystemFont(ofSize: 17),
                           range: (title as NSString).range(of: title))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = .white
        button.backgroundColor = PQColor.buttonMain
        button.layer.cornerRadius = 8
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
    
    override func prepareForReuse() {
        titleLabel.text = ""
        valueLabel.text = ""
    }
    
    private func setSubviews() {
        [titleLabel, valueLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        contentView.addSubview(modifyButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            modifyButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            modifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            modifyButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
        ])
    }
}

extension ModifyingListCell {
    func configure(with item: ModifyingItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}
