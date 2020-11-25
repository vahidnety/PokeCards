//
//  Pokemons.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import SwiftyJSON

struct PokemonsList {
    var idCard: String!
    var name: String!
    var imageUrl: String!
    var pokedexNumber: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        idCard = json["id"].stringValue
        name = json["name"].stringValue
        imageUrl = json["imageUrl"].stringValue
        pokedexNumber = json["nationalPokedexNumber"].stringValue
    }

    init(idCard: String, name: String, imageUrl: String, pokedexNumber: String) {
        self.idCard = idCard
        self.name = name
        self.imageUrl = imageUrl
        self.pokedexNumber = pokedexNumber
    }
}
