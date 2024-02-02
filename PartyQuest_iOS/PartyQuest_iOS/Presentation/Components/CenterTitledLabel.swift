//
//  CenterTitledLabel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/23.
//

import UIKit

final class CenterTitledLabel: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = PQColor.text
        label.textAlignment = .center
        label.font = PQFont.basic
        
        return label
    }()
    
    let bodyLabel: LeftImageLabel = .init()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 5, bottom: 20, right: 5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func setBodyLeftImage(assetName: String?) {
        guard let assetName else { return }
        bodyLabel.setImage(assetName: assetName)
    }
    
    func setBodyText(_ text: String?) {
        bodyLabel.setText(text)
    }
    
    func setBodyFont(_ font: UIFont) {
        bodyLabel.setFont(font)
    }
    
    private func setSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        self.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
