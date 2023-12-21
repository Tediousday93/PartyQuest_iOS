//
//  TitledTextfield.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/10/27.
//

import UIKit

final class TitledTextField: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .body)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = .init(width: 10, height: 10)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 4
        textField.backgroundColor = PQColor.white
        
        return textField
    }()
    
    let captionLabel: UILabel  = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemRed
        
        return label
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
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        [titleLabel, textField, captionLabel].forEach {
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
            
            textField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
//    private func setBindings() {
//        inputStateRelay
//            .asDriver(onErrorJustReturn: .correct)
//            .drive(with: self, onNext: { owner, inputState in
//                owner.setTextFieldBorder(state: inputState)
//
//                switch inputState {
//                case .correct:
//                    owner.setCaption(" ")
//                case .incorrect:
//                    owner.setCaption("올바르지 않은 형식입니다.")
//                }
//            })
//            .disposed(by: disposeBag)
//    }
}

extension TitledTextField {
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func setPlaceholder(_ text: String?) {
        textField.placeholder = text
    }
    
    func setTextFieldBorder(color: UIColor) {
        textField.layer.borderColor = color.cgColor
    }
    
    func setCaption(_ caption: String?) {
        captionLabel.text = caption
    }
}
