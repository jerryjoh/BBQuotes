//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Jerry Johnson on 7/16/25.
//

import Foundation

@Observable
@MainActor
class ViewModel {
	enum FetchStatus {
		case notStarted
		case fetching
		case successQuote
		case successEpisode
		case failed(error: Error)
	}
	
	private(set) var status: FetchStatus = .notStarted
	
	private let fetcher = FetchService()
	
	var quote: Quote
	var char: Char
	var episode: Episode
	
	init() {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		
		let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
		quote = try! decoder.decode(Quote.self, from: quoteData)
		
		let charData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
		char = try! decoder.decode(Char.self, from: charData)
		
		let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
		episode = try! decoder.decode(Episode.self, from: episodeData)
	}
	
	func getQuoteData(for show: String) async {
		status = .fetching
		
		do {
			quote = try await fetcher.fetchQuote(from: show)
			
			char = try await fetcher.fetchCharacter(quote.character)
			
			char.death = try await fetcher.fetchDeath(for: char.name)
			
			status = .successQuote
		}
		catch {
			status = .failed(error: error)
		}
	}
	
	func getEpisodeData(for show: String) async {
		status = .fetching
		
		do {
			if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
				episode = unwrappedEpisode
			}
			
			status = .successEpisode
		}
		catch {
			status = .failed(error: error)
		}
	}
}

