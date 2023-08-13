//
//  PokedexViewModelTests.swift
//  pokedexTests
//
//  Created by Joshua Ho on 8/7/23.
//

import XCTest
import Combine
@testable import pokedex

final class PokedexViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = Set<AnyCancellable>()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_getPokemon_success() async throws {
        let exp = XCTestExpectation(description: "expecting getPokemon succeeds")
        let viewModel = PokedexViewModel(service: MockPokedexService(fileName: .getPokemonSuccess))
        
        await viewModel.getPokemon()
        
        viewModel.$pokedex
            .dropFirst()
            .sink { pokedex in
                XCTAssert((pokedex?.results.count)! > 0)
                XCTAssert(pokedex?.count == 1281)
                
                let first = pokedex?.results.first!
                
                XCTAssertEqual(first?.name, "bulbasaur")
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    func test_getPokemon_failure() async throws {
        let exp = XCTestExpectation(description: "expecting getPokemon fails")
        let viewModel = PokedexViewModel(service: MockPokedexService(fileName: .getPokemonFailure))
        
        await viewModel.getPokemon()
        
        viewModel.$status
            .dropFirst(2)
            .sink { s in
                XCTAssert(s == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }

}

enum FileName: String {
    case getPokemonSuccess, getPokemonFailure
}

class MockPokedexService: PokedexServiceProtocol {
    let fileName: FileName
    
    init(fileName: FileName) {
        self.fileName = fileName
    }
    
    private func loadMockData(file: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: file, withExtension: "json")
    }
    
    func fetchPokemon() async throws -> pokedex.PokedexResponse {
        guard let url = loadMockData(file: fileName.rawValue) else { throw APIError.invalidUrl }
        
        let data = try! Data(contentsOf: url)
        
        do {
            return try JSONDecoder().decode(pokedex.PokedexResponse.self, from: data)
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }   
}
