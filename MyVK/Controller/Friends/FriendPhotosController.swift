//
//  FriendPhotosController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendPhotosController: UICollectionViewController {
    
    var friend: User!
    private var photos: Results<Photo>!
    private var realmToken: NotificationToken?
    
    private let inset: CGFloat = 1
    private let numberOfItemsInRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        setToken()
        title = friend.name + "'s photos"
        NetworkManager().getPhotos(of: friend.id)
    }
    
    private func setToken() {
        realmToken = photos.observe { [weak self] changes in
            switch changes {
            case .update(_, let deletions, let insertions, let modifications):
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0)})
                    self?.collectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: 0)})
                    self?.collectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0)})
                }
            case .error, .initial:
                break
            }
            
            
        }
    }
    
    private func loadPhotos() {
        do {
            let realm = try Realm()
            self.photos = realm.objects(Photo.self).filter("ownerId = %d", friend.id)
          
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showPhotosSegue",
              let destination = segue.destination as? PhotoSwipeViewController,
              let indexPath = collectionView.indexPathsForSelectedItems?.first
        else {return}
        
        
        destination.photos = photos
        destination.currentIndex = indexPath.item
    }
    
    deinit {
        realmToken?.invalidate()
    }


    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendPhotoCell", for: indexPath) as? FriendPhotoCell
        else { preconditionFailure("friendPhotoCell error")}
    
        let photo = photos[indexPath.item]
        cell.avatarPicture.imageView.kf.setImage(with: URL(string: photo.url))
        return cell
    }
  

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FriendPhotosController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing = inset * numberOfItemsInRow + 1
        let width = (collectionView.bounds.width - spacing) / numberOfItemsInRow
    return CGSize(width: width, height: width)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return inset
    }
}
