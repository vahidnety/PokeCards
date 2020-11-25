//
//  PokemonsService.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import Moya

public enum PokemonsService {
    case pokemonsCards(offset: Int, limit: Int)
    case detail(idCard: String)
}

extension PokemonsService: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL {
        switch self {
        case let .detail(idCard):
            return URL(string: Constants.Url.base + "cards?id=" + idCard)!
        default:
            return URL(string: Constants.Url.base)!
        }
    }

    public var path: String {
        switch self {
        case .pokemonsCards:
            return "cards"
        case .detail:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .pokemonsCards, .detail:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .pokemonsCards(offset, limit):
            return .requestParameters(parameters: ["page": offset, "pageSize": limit], encoding: URLEncoding.queryString)
        case .detail:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .pokemonsCards, .detail:
            return ["Content-Type": "application/json; charset=utf-8"]
        }
    }

    public var authorizationType: AuthorizationType? {
        switch self {
        case .pokemonsCards, .detail:
            return nil // ?none
        }
    }

    public var validationType: ValidationType {
        switch self {
        case .pokemonsCards, .detail:
            return .successCodes
        }
    }

    public var sampleData: Data {
        "".data(using: String.Encoding.utf8)!
    }
}
