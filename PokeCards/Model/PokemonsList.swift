//
//  PokemonsList.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import SwiftyJSON

struct Pokemon {
    var id: String!
    var name: String!
    var imageURL: String?
    var types: [Any]?

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].stringValue
        name = json["name"].stringValue
        imageURL = json["imageUrl"].string
        types = json["types"].arrayObject
    }
}
