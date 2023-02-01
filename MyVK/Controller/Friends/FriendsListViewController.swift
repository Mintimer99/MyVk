//
//  FriendsListViewController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 29.12.2022.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsListViewController: UIViewController {

    @IBOutlet weak var letterPanel: LetterScrollControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var sectionedFriends: SectionedResults<String, User>!
    private var realmToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriends()
        self.letterPanel.letters = self.sectionedFriends.allKeys
        setToken()
        NetworkManager().getFriends()
        letterPanel.addTarget(self, action: #selector(scroll), for: .allTouchEvents)
    
    }
    
    private func setToken() {
        realmToken = sectionedFriends.observe { [weak self] changes in
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, let insertions, let modifications, let sectionsToInsert, let sectionsToDelete):
                self?.tableView.performBatchUpdates {
                    self?.tableView.deleteRows(at: deletions, with: .none)
                    self?.tableView.insertRows(at: insertions, with: .none)
                    self?.tableView.reloadRows(at: modifications, with: .automatic)
                    self?.tableView.insertSections(sectionsToInsert, with: .automatic)
                    self?.tableView.deleteSections(sectionsToDelete, with: .automatic)
                }
                self?.letterPanel.letters = self?.sectionedFriends.allKeys
            }
        }
    }
    
    private func loadFriends() {
        do {
            let realm = try Realm()
            self.sectionedFriends = realm.objects(User.self).sectioned(by: \.firstLetter)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func scroll() {
        let char = Character(letterPanel.selectedLetter)
        guard let section = sectionedFriends.allKeys.firstIndex(of: String(char)) else { return }
        let indexPath = IndexPath(row: 0, section: section)
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "friendSegue",
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? FriendPhotosController
        else { return }
        destination.friend = sectionedFriends[indexPath]
    }
    
    deinit {
        realmToken?.invalidate()
    }

}


// MARK: - Table View Delegate & Data Source
extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionedFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedFriends[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell
        else { preconditionFailure("friendCell error")}

        let friend = sectionedFriends[indexPath]
        
        cell.nameLabel.text = friend.name
        cell.pictureImageView.kf.setImage(with: URL(string: friend.picture))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionedFriends[section].key
    }

}
