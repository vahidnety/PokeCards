//
//  PokemonsListViewModel.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class PokemonsListViewModel {
    private var mainProvider: MoyaProvider<PokemonsService>

    private var totalCount = 0
    private var limit = 10
    private var offset = 0
    private var isCurrentlyLoading = false
    private var shouldLoadNext = true

    private let _isLoadingMore = PublishSubject<Bool>()
    private let _isLoading = BehaviorRelay(value: false)
    private let _alertMessage = PublishSubject<AlertMessage>()
    private let _cells = BehaviorRelay<[PokemonsViewModelProtocol]>(value: [])

    var onShowingLoading: Observable<Bool> {
        _isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onShowingLoadingMore: Observable<Bool> {
        _isLoadingMore.asObservable()
            .distinctUntilChanged()
    }

    var onShowAlert: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var pokemonCells: Observable<[PokemonsViewModelProtocol]> {
        _cells.asObservable()
    }

//    var pokemonCellsCount: Int {
//        return _cells.value.count
//    }

    init(mainProvider: MoyaProvider<PokemonsService>) {
        self.mainProvider = mainProvider
    }

    func fetchPokemonCards(isLoadingMore: Bool = false) {
        if isCurrentlyLoading {
            return
        }

        if isLoadingMore {
            if totalCount - limit > offset {
                offset += limit
                _isLoadingMore.onNext(true)
            } else {
                _isLoadingMore.onNext(false)
                return
            }
        } else {
            _isLoading.accept(true)
        }

        isCurrentlyLoading = true

        mainProvider.request(.pokemonsCards(offset: offset, limit: limit), completion: { result in

            self._isLoading.accept(false)
            self.isCurrentlyLoading = false

            switch result {
            case let .success(value):

                do {
                    let filteredResponse = try value.filterSuccessfulStatusCodes()
                    let json = JSON(filteredResponse.data)
                    print(value.response?.headers.dictionary)

                    let total = value.response?.headers.dictionary["total-count"]
                    self.totalCount = Int(total!)!

                    let items = json["cards"].arrayValue.compactMap {
                        PokemonsList(fromJson: $0)
                    }

                    let links = value.response?.headers.dictionary["Link"]?.description

                    if links?.contains("next") == true {
                        self._isLoadingMore.onNext(true)
                    } else {
                        self._isLoadingMore.onNext(false)
                    }

                    self._cells.accept(self._cells.value + items)

                } catch {
                    self._alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            case let .failure(error):

                self._alertMessage.onNext(AlertMessage(title: error.errorDescription, message: ""))
            }
        })
    }
}
