//
//  SignUpViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import UIKit

class SignUpViewController: UIViewController {
    let viewModel: SignUpViewModel
    
    init(signUpViewModel: SignUpViewModel) {
        viewModel = signUpViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
}
