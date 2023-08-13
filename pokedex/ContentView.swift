//
//  ContentView.swift
//  pokedex
//
//  Created by Joshua Ho on 8/6/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokedexViewModel()
    var body: some View {
        VStack {
            NavigationView {
                List(viewModel.pokedex?.results ?? [], id: \.self) { pokemon in
                    HStack {
                        AsyncImage(url: URL(string: "https://img.pokemondb.net/artwork/large/\(pokemon.name).jpg")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 120, maxHeight: 120)
                        } placeholder: {
                            Image(systemName: "photo")
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text(pokemon.name.capitalized)
                                .bold()
                                .font(.title2)
                            Text("#\(pokemon.url.suffix(3).replacingOccurrences(of: "/", with: ""))")
                                .italic()
                                .foregroundColor(.gray)
                            Button {
                                print(pokemon.name)
                            } label: {
                                Text("See More")
                            }
                        }
                    }
                }
                .navigationTitle("Pokedex")
            }
        }
        .onAppear {
            viewModel.getPokemon()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
