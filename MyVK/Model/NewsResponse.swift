//
//  NewsResponse.swift
//  MyVK
//
//  Created by Mintimer Kharasov on 17/01/23.
//

import Foundation

struct NewsResponse: Decodable {
    var items: [News]
    var profiles: [Int: User]
    var groups: [Int: Group]
    
    enum CodingKeys: CodingKey {
        case items
        case response
        case profiles
        case groups
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try response.decode([News].self, forKey: .items)
        let profiles = try response.decode([User].self, forKey: .profiles)
        let groups = try response.decode([Group].self, forKey: .groups)
        self.profiles = profiles.reduce(into: [Int: User](), { partialResult, user in
            partialResult[user.id] = user
        })
        self.groups = groups.reduce(into: [Int: Group](), { partialResult, group in
            partialResult[group.id] = group
        })
     
    }
    
    private func myFunc() {
        
    }
}

class News: Decodable {
    var sourceId: Int
    var date: Date
    var comments: Int
    var likes: Int
    var isLiked: Bool
    var reposts: Int
    var text: String
    var views: Int
    var photos: [String]
    
    var needRowsCount: Int {
        if !text.isEmpty && !photos.isEmpty {
            return 4
        } else if !text.isEmpty || !photos.isEmpty {
            return 3
        } else {
            return 2
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case comments, likes, reposts, text, date, attachments
        case views
        case sourceId = "source_id"
    }
    
    enum CountCodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(Date.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
        let commentsContainer = try container.nestedContainer(keyedBy: CountCodingKeys.self, forKey: .comments)
        self.comments = try commentsContainer.decode(Int.self, forKey: .count)
        let likesContainer = try container.nestedContainer(keyedBy: CountCodingKeys.self, forKey: .likes)
        let userLikes = try likesContainer.decode(Int.self, forKey: .userLikes)
        self.likes = try likesContainer.decode(Int.self, forKey: .count)
        self.isLiked = userLikes == 1
        let repostsContainer = try container.nestedContainer(keyedBy: CountCodingKeys.self, forKey: .reposts)
        self.reposts = try repostsContainer.decode(Int.self, forKey: .count)
        let viewsContainer = try container.nestedContainer(keyedBy: CountCodingKeys.self, forKey: .views)
        self.views = try viewsContainer.decode(Int.self, forKey: .count)
        let attachments = try container.decode([Attachment].self, forKey: .attachments)
        
        self.photos = []
        for attachment in attachments {
            guard let photo = attachment.photo else { return }
            photo.sizes.forEach {
                if $0.type == "x" {
                    self.photos.append($0.url)
                }
            }
        }
    }
}

struct Attachment: Decodable {
    var photo: ContentPhoto?
}

struct ContentPhoto: Decodable {
    var sizes: [Photo]
}
