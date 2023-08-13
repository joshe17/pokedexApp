//
//  PokedexResponse.swift
//  pokedex
//
//  Created by Joshua Ho on 8/7/23.
//

import Foundation

struct PokedexResponse: Decodable {
    let count: Int
    let results: [Pokemon]
}

struct Pokemon: Decodable, Hashable {
    let name: String
    let url: String
}
