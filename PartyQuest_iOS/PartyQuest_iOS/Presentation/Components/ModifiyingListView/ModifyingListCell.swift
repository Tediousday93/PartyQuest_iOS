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
        label.textColor = PQColor.lightGray
        
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
        button.setTitle("수정", for: .normal)
        button.tintColor = .white
        button.backgroundColor = PQColor.buttonMain
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
        setAccessories()
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
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setAccessories() {
        let accessoryConfiguration = UICellAccessory.CustomViewConfiguration(
            customView: modifyButton,
            placement: .trailing()
        )
        
        let trailingModifyButton = UICellAccessory.customView(configuration: accessoryConfiguration)
        
        self.accessories = [trailingModifyButton]
    }
}

extension ModifyingListCell {
    func configure(with item: ModifyingItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}
