//
//  NewsfeedController.swift
//  MyVK
//
//  Created by Mintimer Kharasov on 22/01/23.
//

import UIKit
import Kingfisher

class NewsfeedController: UITableViewController {
    
    var newsfeed: NewsResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().getNews { newsfeed in
            self.newsfeed = newsfeed
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    private func setupCell(for indexPath: IndexPath) -> UITableViewCell? {
        guard let news = newsfeed?.items[indexPath.section],
              let poster: PosterProtocol = news.sourceId < 0 ? newsfeed?.groups[news.sourceId * -1] : newsfeed?.profiles[news.sourceId] else { return nil }
        switch indexPath.row {
        case 0:
            return getPosterCell(for: news, with: poster, at: indexPath)
        case 1:
            switch news.needRowsCount {
            case 4: return getTextCell(for: news, at: indexPath)
            case 3: return news.text.isEmpty ? getPhotoCell(for: news, at: indexPath) : getTextCell(for: news, at: indexPath)
            case 2: return getLCRCell(for: news, at: indexPath)
            default: return nil
            }
        case 2:
            switch news.needRowsCount {
            case 4: return getPhotoCell(for: news, at: indexPath)
            case 2, 3: return getLCRCell(for: news, at: indexPath)
            default: return nil
            }
        case 3:
            return getLCRCell(for: news, at: indexPath)
        default: return nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsfeed?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsfeed?.items[section].needRowsCount ?? 0
//        return 4
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = setupCell(for: indexPath) else { preconditionFailure("Cell ERROR") }

        return cell
    }
}

    // MARK: - get cell methods

extension NewsfeedController {
    private func getLCRCell(for news: News, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postActionsCell", for: indexPath)
        guard let lcr = cell.viewWithTag(1) as? LCRConrol else { return UITableViewCell() }
        lcr.likeButton.isLiked = news.isLiked
        lcr.likeButton.likesCount = news.likes
        lcr.commentsButton.commentLabel.text = String(news.comments)
        lcr.repostButton.shareLabel.text = String(news.reposts)
        lcr.seenView.seenLabel.text = String(news.views)
        return cell
    }
    
    private func getPhotoCell(for news: News, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postPhotoCell", for: indexPath)
        (cell.viewWithTag(1) as? UIImageView)?.kf.setImage(with: URL(string: news.photos.first ?? ""))
        return cell
    }
    
    private func getTextCell(for news: News, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
        (cell.viewWithTag(1) as? UILabel)?.text = news.text
        return cell
    }
    
    private func getPosterCell(for news: News, with poster: PosterProtocol, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "posterCell", for: indexPath)
        (cell.viewWithTag(3) as? UIImageView)?.kf.setImage(with: URL(string: poster.picture))
        (cell.viewWithTag(1) as? UILabel)?.text = poster.name
        let df = DateFormatter()
        df.dateFormat = "d/MM HH:mm"
        (cell.viewWithTag(2) as? UILabel)?.text = df.string(from: news.date)
        return cell
    }
}
