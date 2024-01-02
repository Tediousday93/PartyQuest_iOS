//
//  DropDownButton.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit
import RxSwift
import RxCocoa

final class DropDownButton: UIView {
    let titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = PQColor.white
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 10
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
    
    lazy var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.9)
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return view
    }()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private let menuItems: BehaviorRelay<[String]> = .init(value: [])
    private let menuHeight: CGFloat
    private let rootView: UIView
    private var disposeBag: DisposeBag
    
    init(menuItems: [String],
         menuHeight: CGFloat,
         rootView: UIView) {
        self.menuItems.accept(menuItems)
        self.menuHeight = menuHeight
        self.rootView = rootView
        self.disposeBag = .init()
        super.init(frame: .zero)
        configureTableView()
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.disposeBag = .init()
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
            arrowIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        ])
    }
    
    private func configureTableView() {
        tableView.separatorInset = .zero
        tableView.rowHeight = 50
        tableView.layer.cornerRadius = 5
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.reuseID)
    }
    
    private func setBindings() {
        self.menuItems
            .bind(to: tableView.rx.items) { tableView, row, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.reuseID) as? DropDownCell else {
                    return UITableViewCell()
                }
                cell.menuLabel.text = item
                
                return cell
            }
            .disposed(by: disposeBag)
        
        titleButton.rx.tap.asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.showDropDownMenu()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(with: self, onNext: { owner, indexPath in
                owner.titleButton.setTitle(owner.menuItems.value[indexPath.row], for: .normal)
                owner.removeDropDownMenu()
            })
            .disposed(by: disposeBag)
        
        tapGestureRecognizer.rx.event.asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.removeDropDownMenu()
            })
            .disposed(by: disposeBag)
    }
    
    private func showDropDownMenu() {
        let buttonFrame = titleButton.frame
        rootView.insertSubview(transparentView, belowSubview: self)
        self.addSubview(tableView)
        transparentView.frame = rootView.frame
        transparentView.alpha = 0
        
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
            self.transparentView.alpha = 0.5
        }
    }
    
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
            self.transparentView.alpha = 0
        }
    }
}

extension DropDownButton {
    func setButton(title: String) {
        titleButton.setTitle(title, for: .normal)
    }
    
    func setTitleInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
            titleButton.configuration = config
        } else {
            titleButton.titleEdgeInsets = .init(top: top, left: leading, bottom: bottom, right: trailing)
        }
    }
}
