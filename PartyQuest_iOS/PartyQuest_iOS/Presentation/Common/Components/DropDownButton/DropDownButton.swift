//
//  DropDownButton.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit

final class DropDownButton: UIView {
    let titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = PQColor.white
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 15
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let arrowIndicatorView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let tableView: UITableView = .init()
    
    private var menuItems: [String]
    private let menuHeight: CGFloat
    
    init(menuItems: [String], menuHeight: CGFloat) {
        self.menuItems = menuItems
        self.menuHeight = menuHeight
        super.init(frame: .zero)
        configureSubviews()
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        self.addSubview(titleButton)
        self.addSubview(arrowIndicatorView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: self.topAnchor),
            titleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleButton.heightAnchor.constraint(equalToConstant: 50),
            
            arrowIndicatorView.centerYAnchor.constraint(equalTo: titleButton.centerYAnchor),
            arrowIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.reuseID)
        
        titleButton.addTarget(self, action: #selector(showDropDownMenu), for: .touchUpInside)
    }
    
    @objc
    private func showDropDownMenu() {
        let buttonFrame = titleButton.frame
        self.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) {
            self.tableView.frame = CGRect(
                x: buttonFrame.origin.x,
                y: buttonFrame.origin.y + buttonFrame.height,
                width: buttonFrame.width,
                height: self.menuHeight
            )
        }
    }
    
    @objc
    private func removeDropDownMenu() {
        let buttonFrame = titleButton.frame
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) {
            self.tableView.frame = CGRect(
                x: buttonFrame.origin.x,
                y: buttonFrame.origin.y + buttonFrame.height,
                width: buttonFrame.width,
                height: 0
            )
        }
    }
}

extension DropDownButton {
    func setButton(title: String) {
        titleButton.setTitle(title, for: .normal)
    }
}

extension DropDownButton: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.reuseID, for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        cell.menuLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleButton.setTitle(menuItems[indexPath.row], for: .normal)
        removeDropDownMenu()
    }
}
