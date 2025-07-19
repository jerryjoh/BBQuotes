//
//  Untitled.swift
//  BBQuotes
//
//  Created by Jerry Johnson on 7/19/25.
//

extension String {
	func removeSpaces() -> String {
		return self.replacingOccurrences(of: " ", with: "")
	}
	
	func removeCaseAndSpaces() -> String {
		return self.lowercased().removeSpaces()
	}
}
