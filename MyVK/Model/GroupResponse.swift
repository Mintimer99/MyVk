//
//  Group.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit
import RealmSwift

struct GroupResponse: Decodable {
    var items: [Group]
    
    enum ResponseKeys: CodingKey {
        case response
    }
    
    enum ItemsKeys: CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        let response = try container.nestedContainer(keyedBy: ItemsKeys.self, forKey: .response)
        items = try response.decode([Group].self, forKey: .items)
    }
    
}

class Group: Object, Decodable, PosterProtocol {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var picture: String
    
    var toAnyObject: Any {
        ["id": id, "name": name]
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case picture = "photo_200"
    }

}
