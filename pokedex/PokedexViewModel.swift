//
//  PokedexViewModel.swift
//  pokedex
//
//  Created by Joshua Ho on 8/7/23.
//

import Foundation

enum AsyncStatus {
    case initial, loading, loaded, error
}

class PokedexViewModel: ObservableObject {
    @Published var pokedex: PokedexResponse?
    @Published var status: AsyncStatus = .initial
    
    let service: PokedexServiceProtocol
    
    init(service: PokedexServiceProtocol = PokedexService()) {
        self.service = service
    }
    
    @MainActor func getPokemon() {
        Task {
            do {
                status = .loading
                pokedex = try await service.fetchPokemon()
                status = .loaded
            } catch {
                print(error)
                status = .error
            }
        }
    }
}
