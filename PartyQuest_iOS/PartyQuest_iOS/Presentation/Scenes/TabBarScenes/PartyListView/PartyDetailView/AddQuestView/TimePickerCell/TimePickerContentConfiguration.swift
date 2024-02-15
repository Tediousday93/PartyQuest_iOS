//
//  TimePickerContentConfiguration.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/14.
//

import UIKit

struct TimePickerContentConfiguration: UIContentConfiguration {
    var item: TimePickerItem?

    func makeContentView() -> UIView & UIContentView {
        return TimePickerContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
