//
//  ContentTableViewController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 30.12.2022.
//

import UIKit
import FirebaseDatabase

class ContentTableViewController: UITableViewController {
    
    private var newsfeed: NewsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: "NewsfeedCell")
        NetworkManager().getNews { news in
            self.newsfeed = news
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsfeed?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsfeedCell", for: indexPath) as? NewsfeedCell
        else { preconditionFailure("NewsfeedCell Error") }
        let news = newsfeed?.items[indexPath.section]
        cell.poster = news!.sourceId < 0 ? newsfeed?.groups[news!.sourceId * -1] : newsfeed?.profiles[news!.sourceId]
        cell.news = news
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
}
