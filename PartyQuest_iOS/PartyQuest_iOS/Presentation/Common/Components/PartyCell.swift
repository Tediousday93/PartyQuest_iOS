//
//  PartyCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/12.
//

import UIKit

final class PartyCell: UICollectionViewCell {
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let memberCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
}
