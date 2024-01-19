//
//  HomeCollectionHeaderView.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/14.
//

import UIKit

final class CollectionTitleHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = PQColor.text
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureTitle(string: nil)
    }
    
    func configureTitle(string title: String?) {
        titleLabel.text = title
    }
    
    func setFont(_ font: UIFont) {
        titleLabel.font = font
    }
    
    func setAlignment(_ alignment: NSTextAlignment) {
        titleLabel.textAlignment = alignment
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
