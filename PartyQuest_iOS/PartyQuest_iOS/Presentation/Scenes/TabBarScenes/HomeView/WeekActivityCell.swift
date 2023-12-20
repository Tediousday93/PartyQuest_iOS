//
//  WeekActivityCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/19.
//

import UIKit

final class WeekActivityCell: UICollectionViewCell {
    private let bulbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PQColor.buttonMain
        
        return imageView
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PQColor.buttonMain
        
        return imageView
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PQColor.buttonMain
        
        return imageView
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = PQColor.buttonMain
        
        return imageView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let questTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        label.text = "Total Quest"
        
        return label
    }()
    
    private let completeTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        label.text = "Total Complete"
        
        return label
    }()
    
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        label.text = "Total Posts"
        
        return label
    }()
    
    private let commentTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        label.text = "Total Comments"
        
        return label
    }()
    
    private let titleLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let questCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        
        return label
    }()
    
    private let completeCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        
        return label
    }()
    
    private let postCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        
        return label
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basicBold
        
        return label
    }()
    
    private let countLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    let achievementRateView = CircularProgressView()
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = PQSpacing.side
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        setSubViews()
        configureImages()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        questCountLabel.text = ""
        completeCountLabel.text = ""
        postCountLabel.text = ""
        commentCountLabel.text = ""
        achievementRateView.prepareToReuse()
    }

    func configure(with weekActivity: WeekActivity) {
        questCountLabel.text = "\(weekActivity.questCount)"
        completeCountLabel.text = "\(weekActivity.completeCount)"
        postCountLabel.text = "\(weekActivity.postCount)"
        commentCountLabel.text = "\(weekActivity.commentCount)"
        achievementRateView.setProgressColor = PQColor.buttonMain
        achievementRateView.setTrackColor = PQColor.buttonMain.withAlphaComponent(0.2)
        achievementRateView.setProgressWithAnimation(duration: 1, value: weekActivity.completeRate)
    }
    
    private func configureContentView() {
        contentView.backgroundColor = PQColor.white
    }
    
    private func setSubViews() {
        imageStackView.addArrangedSubview(bulbImageView)
        imageStackView.addArrangedSubview(bookImageView)
        imageStackView.addArrangedSubview(postImageView)
        imageStackView.addArrangedSubview(commentImageView)
        
        titleLabelStackView.addArrangedSubview(questTitleLabel)
        titleLabelStackView.addArrangedSubview(completeTitleLabel)
        titleLabelStackView.addArrangedSubview(postTitleLabel)
        titleLabelStackView.addArrangedSubview(commentTitleLabel)
        
        countLabelStackView.addArrangedSubview(questCountLabel)
        countLabelStackView.addArrangedSubview(completeCountLabel)
        countLabelStackView.addArrangedSubview(postCountLabel)
        countLabelStackView.addArrangedSubview(commentCountLabel)
        
        outerStackView.addArrangedSubview(imageStackView)
        outerStackView.addArrangedSubview(titleLabelStackView)
        outerStackView.addArrangedSubview(countLabelStackView)
        outerStackView.addArrangedSubview(achievementRateView)
        
        contentView.addSubview(outerStackView)
    }
    
    private func configureImages() {
        bulbImageView.image = UIImage(systemName: "lightbulb.fill")
        bookImageView.image = UIImage(systemName: "book.closed.fill")
        postImageView.image = UIImage(systemName: "note.text")
        commentImageView.image = UIImage(systemName: "bubble.left.fill")
    }
    
    private func setConstraints() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
