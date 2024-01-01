//
//  PartySearchViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/01.
//

import UIKit
import RxSwift
import RxCocoa

final class PartySearchViewController: UIViewController {
    private let dropDownButton: DropDownButton = {
        let menuItems = ["파티 이름", "파티장"]
        let button = DropDownButton(menuItems: menuItems, menuHeight: 100)
        button.setButton(title: "검색기준")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        textField.leftView = imageView
        textField.placeholder = "Search Party"
        textField.backgroundColor = .systemGray5
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func configureRootView() {
        view.backgroundColor = .systemGray6
    }
    
    private func setSubviews() {
        view.addSubview(dropDownButton)
    }
    
    private func setConstraints() {
        
    }

}
