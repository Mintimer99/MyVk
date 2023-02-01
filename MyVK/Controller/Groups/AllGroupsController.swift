//
//  AllGroupsController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit
import Kingfisher

class AllGroupsController: UIViewController {
    
    @IBOutlet weak var loadingView: LoadingDotsControl!
    
    @IBOutlet weak var searchControl: SearchControl!
    @IBOutlet weak var tableView: UITableView!
    
    var groupsSearching = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        
        searchControl.addTarget(self, action: #selector(performSearch), for: .editingChanged)
        
    }
    
    @objc private func performSearch() {
        NetworkManager().searchGroups(with: searchControl.searchText) { groups in
            self.groupsSearching = groups
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
   
    }
    
}


// MARK: - Table view data source

extension AllGroupsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        groupsSearching.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        else { preconditionFailure("allGroupsCell error")}
        
        let group = groupsSearching[indexPath.row]
        cell.nameLabel.text = group.name
        cell.pictureImageView.kf.setImage(with: URL(string: group.picture))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindAndSaveGroup", sender: nil)
    }
    
}
