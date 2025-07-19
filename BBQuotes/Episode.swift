//
//  Episode.swift
//  BBQuotes
//
//  Created by Jerry Johnson on 7/19/25.
//

import Foundation

// MARK: - Welcome
struct Episode: Decodable {
	let episode: Int
	let title: String
	let image: URL
	let synopsis, writtenBy, directedBy, airDate: String
	
	var seasonEpisode: String {
		"Season \(episode / 100) Episode\(episode % 100)"
	}
}
