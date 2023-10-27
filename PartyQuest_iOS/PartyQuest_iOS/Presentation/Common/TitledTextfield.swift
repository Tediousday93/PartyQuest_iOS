//
//  TitledTextfield.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/10/27.
//

import UIKit

final class TitledTextfield: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .body)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 3
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
    
    private func setSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        
        self.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
}
