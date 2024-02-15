//
//  DatePickerContentConfiguration.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/13.
//

import UIKit

struct DatePickerContentConfiguration: UIContentConfiguration {
    var item: DatePickerItem?

    func makeContentView() -> UIView & UIContentView {
        return DatePickerContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
