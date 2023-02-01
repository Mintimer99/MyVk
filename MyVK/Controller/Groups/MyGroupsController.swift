//
//  MyGroupsController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit
import Kingfisher
import RealmSwift

class MyGroupsController: UITableViewController {
    
    private var groups: Results<Group>!
    private var realmToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        loadGroups()
        setToken()
        NetworkManager().getGroups(for: Session.instance.userID)
    }
    
    private func setToken() {
        realmToken = groups.observe { [weak self] changes in
            switch changes {
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.performBatchUpdates {
                    self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0)}, with: .none)
                    self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0)},
                                               with: .none)
                    self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0)},
                                               with: .automatic)
                }
            case .error, .initial:
                break
            }
        }
    }
    
    private func loadGroups() {
        do {
            let realm = try Realm()
            self.groups = realm.objects(Group.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        realmToken?.invalidate()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        else { preconditionFailure("MyGroupCell error")}

        cell.nameLabel.text = groups[indexPath.row].name
        cell.pictureImageView.kf.setImage(with: URL(string: groups[indexPath.row].picture))

        return cell
    }
    
    @IBAction func unwindAndSaveGroup(_ segue: UIStoryboardSegue) {
        guard let source = segue.source as? AllGroupsController,
              let indexPath = source.tableView.indexPathForSelectedRow
        else {return}
        
        let newGroup = source.groupsSearching[indexPath.row]
        if !groups.contains(where: { $0.id == newGroup.id}) {
            FBDatabaseManager().add(newGroup)
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(newGroup)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                try realm.write {
                    let group = groups[indexPath.row]
                    realm.delete(group)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
