//
//  DropDownCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/20.
//

import UIKit

final class DropDownCell: UITableViewCell {
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        contentView.addSubview(menuLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            menuLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            menuLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            menuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
}
