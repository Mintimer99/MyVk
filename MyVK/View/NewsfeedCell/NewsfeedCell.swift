//
//  NewsfeedCell.swift
//  MyVK
//
//  Created by Mintimer Kharasov on 18/01/23.
//

import UIKit
import Kingfisher

class NewsfeedCell: UITableViewCell {

    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var picturesStackView: UIStackView!
    @IBOutlet weak var lcrPanel: LCRConrol!
    
    
    var poster: PosterProtocol!
    var news: News! {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        bcView.layer.cornerRadius = 20
    }
    
    private var splitImages = [[UIImageView]]()
    
    private func setupCell() {
        for stackView in picturesStackView.arrangedSubviews {
            stackView.removeFromSuperview()
        }
        splitImages.removeAll()
        setupPosterPanel()
        setupContent()
        setupLCRPanel()
    }
    
    private func setupLCRPanel() {
        lcrPanel.likeButton.likesCount = news.likes
        lcrPanel.likeButton.isLiked = news.isLiked
        lcrPanel.commentsButton.commentLabel.text = String(news.comments)
        lcrPanel.repostButton.shareLabel.text = String(news.reposts)
        lcrPanel.seenView.seenLabel.text = String(news.views)
    }
    
    private func setupPosterPanel() {
        posterImage.kf.setImage(with: URL(string: poster.picture))
        posterImage.layer.cornerRadius = posterImage.frame.height / 2
        posterNameLabel.text = poster.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM HH:mm"
        postDateLabel.text = dateFormatter.string(from: news.date)
    
    }
    
    private func setupContent() {
        postTextLabel.text = news.text
        setupStackViews()
    }
    
    private func setupStackViews() {
        let imageViews = createImageViews()
        split(imageViews)
        
        for imageArray in splitImages {
            let stackView = createStackView(with: imageArray)
            picturesStackView.addArrangedSubview(stackView)
        }
    }
    
    private func createStackView(with images: [UIImageView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: images)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / CGFloat(images.count))
        ])
        
        return stackView
    }
    
    private func createImageViews() -> [UIImageView] {
        
        var resultArray = [UIImageView]()
        for image in news.photos {
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: image))
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 2
            
            resultArray.append(imageView)
        }
        
        return resultArray
    }
    
    
    private func split(_ images: [UIImageView]) {
        switch images.count {
        case 1...3:
            splitImages.append(Array(images[0...images.count - 1]))
        case 4, 5, 7, 8:
            splitImages.append(Array(images[0...1]))
            splitImages.append(Array(images[2...images.count - 1]))
        case 6:
            splitImages.append(Array(images[0...2]))
            splitImages.append(Array(images[3...5]))
        case 9:
            splitImages.append(Array(images[0...2]))
            splitImages.append(Array(images[3...5]))
            splitImages.append(Array(images[6...8]))
        default: break
        }
    }
    
}
