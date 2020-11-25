//
//  PokemonsViewModelProtocol.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation

protocol PokemonsViewModelProtocol {
    var pokemonsList: PokemonsList { get }
    var titleViewModel: String { get }
    var imageUrlViewModel: String { get }
    var subTitleViewModel: String { get }
}

extension PokemonsList: PokemonsViewModelProtocol {
    var pokemonsList: PokemonsList {
        self
    }

    var titleViewModel: String {
        name
    }

    var imageUrlViewModel: String {
        imageUrl
    }

    var subTitleViewModel: String {
        pokedexNumber
    }
}
