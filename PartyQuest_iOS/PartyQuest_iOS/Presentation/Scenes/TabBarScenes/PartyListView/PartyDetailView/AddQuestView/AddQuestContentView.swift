//
//  AddQuestContentView.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/02.
//

import UIKit

final class AddQuestContentView: UIView {
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "제목을 입력하세요."
        titleTextField.backgroundColor = PQColor.white
        titleTextField.layer.cornerRadius = 8
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        let paddingView = UIView(frame: .init(x: 0,
                                              y: 0,
                                              width: 20,
                                              height: titleTextField.frame.height))
        titleTextField.leftView = paddingView
        titleTextField.rightView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.rightViewMode = .always
        
        return titleTextField
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 16.0, bottom: 10, right: 16.0)
        textView.textContainer.lineBreakMode = .byCharWrapping
        
        textView.text = "설명을 입력하세요."
        textView.font = PQFont.basic
        textView.textColor = PQColor.textGray

        return textView
    }()

    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
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
        textFieldStackView.addArrangedSubview(titleTextField)
        textFieldStackView.addArrangedSubview(descriptionTextView)
        
        addSubview(textFieldStackView)
    }
    
    private func setConstraints() {
        guard let textViewfont = descriptionTextView.font else { return }
        let lineSpacing = descriptionTextView.textContainer.lineFragmentPadding * 2
        let topBottomContainerInset = descriptionTextView.textContainerInset.top + descriptionTextView.textContainerInset.bottom
        let textViewHeight = (textViewfont.capHeight + lineSpacing) * 6 + topBottomContainerInset
        
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 42),
            descriptionTextView.heightAnchor.constraint(equalToConstant: textViewHeight),
            
            textFieldStackView.topAnchor.constraint(equalTo: self.topAnchor),
            textFieldStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textFieldStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

}
