//
//  Appdelegate+extension.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import Moya
import Swinject

extension AppDelegate {
    /**
     Set up the depedency graph in the DI container
     */
    func setupDependencies() {
        // MARK: - Providers

        container.register(MoyaProvider<PokemonsService>.self, factory: { _ in
            MoyaProvider<PokemonsService>()
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(PokemonsListViewModel.self, factory: { container in
            PokemonsListViewModel(mainProvider: container.resolve(MoyaProvider<PokemonsService>.self)!)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers

//        container.storyboardInitCompleted(PokemonsView.self) { r, c in
//            c.viewModel = r.resolve(PokemonsListViewModel.self)
//        }
    }
}
