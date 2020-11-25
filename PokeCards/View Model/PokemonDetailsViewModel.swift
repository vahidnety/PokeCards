//
//  PokemonDetailsViewModel.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class PokemonDetailsViewModel {
    var mainProvider: MoyaProvider<PokemonsService>
    var pokemonsListViewModel: PokemonsViewModelProtocol

    private let _isLoading = BehaviorRelay(value: false)
    private let _alertMessage = PublishSubject<AlertMessage>()
    private let _pokemon = PublishSubject<Pokemon>()

    var onShowingLoading: Observable<Bool> {
        _isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onShowAlert: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var pokemon: Observable<Pokemon> {
        _pokemon.asObservable()
    }

    init(mainProvider: MoyaProvider<PokemonsService>, pokemonsListViewModel: PokemonsViewModelProtocol) {
        self.mainProvider = mainProvider
        self.pokemonsListViewModel = pokemonsListViewModel
    }

    func fetchPokemonDetail() {
        _isLoading.accept(true)
//        print(pokemonsListViewModel.pokemonsList.idCard)

        mainProvider.request(.detail(idCard: pokemonsListViewModel.pokemonsList.idCard), completion: { result in
            self._isLoading.accept(false)

            switch result {
            case let .success(value):
                do {
                    let filteredResponse = try value.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)["cards"][0]
                    let pokemon = Pokemon(fromJson: json)
                    self._pokemon.onNext(pokemon)

                } catch {
                    self._alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            case let .failure(error):
                self._alertMessage.onNext(AlertMessage(title: error.errorDescription, message: ""))
            }
        })
    }
}
