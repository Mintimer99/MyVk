//
//  UserResponse.swift
//  MyVK
//
//  Created by Минтимер Харасов on 08.01.2023.
//

import UIKit
import RealmSwift

struct UserResponse: Decodable {
    let items: [User]
    
    enum ResponseKeys: CodingKey {
        case response
    }
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        items = try response.decode([User].self, forKey: .items)
    }
}

class User: Object, Decodable, PosterProtocol {
    
    @Persisted var id: Int
    @Persisted var picture: String
    @Persisted var name: String = ""
    
    var firstLetter: String {
        guard let char = name.first else { return "" }
        return String(char)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name"]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case picture = "photo_100"
    }
    
   convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.picture = try container.decode(String.self, forKey: .picture)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        self.name = firstName + " " + lastName
    }

}
