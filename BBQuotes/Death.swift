//
//  Death.swift
//  BBQuotes
//
//  Created by Jerry Johnson on 7/15/25.
//

import Foundation

// MARK: - Death
struct Death: Decodable {
	let character: String
	let image: URL
	let details: String
	let lastWords: String
}
