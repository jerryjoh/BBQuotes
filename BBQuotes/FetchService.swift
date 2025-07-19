//
//  FetchService.swift
//  BBQuotes
//
//  Created by Jerry Johnson on 7/15/25.
//

import Foundation

struct FetchService {
	private enum FetchError: Error {
		case badResponse
	}
	
	private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
	
	// https://https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
	func fetchQuote(from show: String) async throws -> Quote {
		// Build fetch URL
		let quoteURL = baseURL.appendingPathComponent("quotes/random")
		let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
		
		// Fetch data
		let (data, response) = try await URLSession.shared.data(from: fetchURL)
		
		// Handle response
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw FetchError.badResponse
		}
		
		// Decode data
		let quote = try JSONDecoder().decode(Quote.self, from: data)
		
		// Return quote
		return quote
	}
	// https://https://breaking-bad-api-six.vercel.app/api/character?name=Walter+White
	func fetchCharacter(_ name: String) async throws -> Char {
		let charURL = baseURL.appending(path: "characters")
		let fetchURL = charURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
		
		let (data, response) = try await URLSession.shared.data(from: fetchURL)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw FetchError.badResponse
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		
		let chars = try decoder.decode([Char].self, from: data)
		
		return chars[0]
	}
	// https://https://breaking-bad-api-six.vercel.app/api/deaths
	func fetchDeath(for character: String) async throws -> Death? {
		let fetchURL = baseURL.appending(path: "deaths")
		
		let (data, response) = try await URLSession.shared.data(from: fetchURL)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw FetchError.badResponse
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		
		let deaths = try decoder.decode([Death].self, from: data)
		
		for death in deaths {
			if death.character == character {
				return death
			}
		}
		
		return nil
	}
	// https://https://breaking-bad-api-six.vercel.app/api/character?name=Walter+White
	func fetchEpisode(from show: String) async throws -> Episode? {
		let episodeURL = baseURL.appending(path: "episodes")
		let fetchURL = episodeURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
		
		let (data, response) = try await URLSession.shared.data(from: fetchURL)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw FetchError.badResponse
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		
		let episodes = try decoder.decode([Episode].self, from: data)
		
		return episodes.randomElement()
	}
}
