//
//  CreatePartyViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit
import RxSwift
import RxCocoa

final class CreatePartyViewController: UIViewController {
    private let partyNameTextField: TitledTextfield = {
        let titledTextField = TitledTextfield()
        titledTextField.setTitle("파티 이름")
        
        return titledTextField
    }()
    
    private let introductionTextView: TitledTextView = {
        let textView = TitledTextView()
        textView.setTitle("파티 소개")
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
