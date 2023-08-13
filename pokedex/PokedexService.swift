//
//  PokedexService.swift
//  pokedex
//
//  Created by Joshua Ho on 8/7/23.
//

import Foundation

enum APIError: Error {
    case invalidUrl, invalidResponse, decodingError
}

protocol PokedexServiceProtocol {
    func fetchPokemon() async throws -> PokedexResponse
}

class PokedexService: PokedexServiceProtocol {
    let urlString = "https://pokeapi.co/api/v2/pokemon/?limit=100&offset=0"
    
    func fetchPokemon() async throws -> PokedexResponse {
        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else { throw APIError.invalidResponse }
        
        return try JSONDecoder().decode(PokedexResponse.self, from: data)
    }
}
