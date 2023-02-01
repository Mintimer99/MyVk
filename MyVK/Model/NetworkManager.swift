//
//  NetworkManager.swift
//  MyVK
//
//  Created by Минтимер Харасов on 08.01.2023.
//

import UIKit
import RealmSwift

class NetworkManager {
    
    private let session: URLSession!
    
    init() {
        let configs = URLSessionConfiguration.default
        session = URLSession(configuration: configs)
    }
    
    private func getURL(method: Method, id: Int, searchText: String) -> URL? {
        var urlComp = URLComponents()
        urlComp.scheme = "https"
        urlComp.host = "api.vk.com"
        urlComp.path = "/method/\(method.rawValue)"
        
        switch method {
        case .friends:
            urlComp.queryItems = [URLQueryItem(name: "fields", value: "photo_100")]
        case .photos:
            urlComp.queryItems = [
                URLQueryItem(name: "owner_id", value: "\(id)"),
                URLQueryItem(name: "album_id", value: "profile")
            ]
        case .userGroups:
            urlComp.queryItems = [
                URLQueryItem(name: "user_id", value: "\(id)"),
                URLQueryItem(name: "extended", value: "1")
                ]
        case .searchGroups:
            urlComp.queryItems = [URLQueryItem(name: "q", value: "\(searchText)")]
        case .news:
            urlComp.queryItems = [URLQueryItem(name: "filters", value: "post")]
        }
        
        urlComp.queryItems?.append(contentsOf: [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131")
        ])
        
       return urlComp.url
    }
    
    private func loadData(method: Method, id: Int = 0, searchText: String = "", _ completionHandler: @escaping (Data?) -> Void)  {
         guard let url = getURL(method: method, id: id, searchText: searchText)
        else { return }
        print(url)
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, _, _ in
            completionHandler(data)
        }.resume()
    }
    
    
}


// MARK: - Enums
extension NetworkManager {
    enum Method: String {
        case friends = "friends.get"
        case photos = "photos.getAll"
        case userGroups = "groups.get"
        case searchGroups = "groups.search"
        case news = "newsfeed.get"
    }
}

// MARK: - Get Methods
extension NetworkManager {
    func getFriends() {
        loadData(method: .friends) { data in
            do {
                let friends = try JSONDecoder().decode(UserResponse.self, from: data!).items
                self.saveInRealm(friends.sorted { $0.name < $1.name })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getGroups(for id: Int) {
        loadData(method: .userGroups, id: id) { data in
            do {
                let groups = try JSONDecoder().decode(GroupResponse.self, from: data!).items
                self.saveInRealm(groups)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func searchGroups(with text: String, _ completionHandler: @escaping ([Group]) -> Void) {
        loadData(method: .searchGroups, searchText: text) { data in
            do {
                let groups = try JSONDecoder().decode(GroupResponse.self, from: data!).items
                completionHandler(groups)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getPhotos(of id: Int) {
        loadData(method: .photos, id: id) { data in
            do {
                let photoItems = try JSONDecoder().decode(PhotosResponse.self, from: data!).response.items
                let photos = photoItems.flatMap { $0.sizes.filter { $0.type == "x" } }
                photos.forEach { $0.ownerId = id }
                self.saveInRealm(photos, for: id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getNews(_ completionHandler: @escaping (NewsResponse) -> Void) {
        loadData(method: .news) { data in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let news = try JSONDecoder().decode(NewsResponse.self, from: data!)
                    completionHandler(news)
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

//MARK: - Realm Methods
extension NetworkManager {
    
    private func saveInRealm<T: Object>(_ data: [T], for id: Int = 0) {
        do {
            let realm = try Realm()
            let oldData = T.self is Photo.Type ? realm.objects(T.self).filter("ownerId = %d", id) : realm.objects(T.self)
            print(realm.configuration.fileURL ?? "no realm")
            
            try realm.write {
                realm.delete(oldData)
                realm.add(data)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
