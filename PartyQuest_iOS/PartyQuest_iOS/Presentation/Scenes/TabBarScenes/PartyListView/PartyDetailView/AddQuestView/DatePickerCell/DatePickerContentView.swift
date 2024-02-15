//
//  DatePickerContentView.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/13.
//

import UIKit

final class DatePickerContentView: UIView, UIContentView {
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = .distantFuture
        datePicker.backgroundColor = PQColor.white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    var configuration: UIContentConfiguration {
        didSet {
            guard let newConfiguration = configuration as? DatePickerContentConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: DatePickerContentConfiguration) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        setSubViews()
        setConstraints()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DatePickerContentView {
    private func setSubViews() {
        addSubview(datePicker)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func apply(configuration: DatePickerContentConfiguration) {
        if case let DatePickerItem.picker(date, action) = configuration.item! {
            datePicker.date = date ?? Date()
            datePicker.addAction(action, for: .valueChanged)
        }
    }
}
