//
//  PhotosResponse.swift
//  MyVK
//
//  Created by Минтимер Харасов on 09.01.2023.
//

import Foundation
import RealmSwift

struct PhotosResponse: Decodable {
    let response: PhotoResponse
    
    struct PhotoResponse: Decodable {
        let items: [Album]
    }
    
    struct Album: Decodable {
        let sizes: [Photo]
    }
}

class Photo: Object, Decodable {
    @Persisted var type: String
    @Persisted var url: String
    @Persisted var ownerId: Int = 0
    
    enum CodingKeys: CodingKey {
        case type, url
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.url = try container.decode(String.self, forKey: .url)
//        self.ownerId = 0
    }
}
