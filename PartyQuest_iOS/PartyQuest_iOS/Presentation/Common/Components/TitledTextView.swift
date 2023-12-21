//
//  TitledTextView.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit

final class TitledTextView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = PQFont.basic
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 4
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
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
        [titleLabel, textView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            textView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

extension TitledTextView {
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    func setTextFieldBorder(flag: Bool) {
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 4
        
        if flag == true {
            textView.layer.borderColor = UIColor.systemGray4.cgColor
        } else {
            textView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}
