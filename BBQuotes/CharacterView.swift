//
//  CharacterView.swift
//  BBQuotes
//
//  Created by Jerry Johnson on 7/15/25.
//

import SwiftUI

struct CharacterView: View {
	let character: Char
	let show: String
	
	var body: some View {
        GeometryReader { geo in
			ScrollViewReader { proxy in
				ZStack {
					Image(show.removeCaseAndSpaces())
						.resizable()
						.scaledToFit()
					
					ScrollView {
						TabView {
							ForEach(character.images, id: \.self) { characterImageURL in
								AsyncImage(url: characterImageURL) { image in
									image
										.resizable()
										.scaledToFill()
								} placeholder: {
									ProgressView()
								}
							}
						}
						.tabViewStyle(.page)
						.frame(width:geo.size.width/1.2, height: geo.size.height/1.7)
						.clipShape(.rect(cornerRadius: 25))
						.padding(.top, 60)
						
						VStack(alignment: .leading) {
							Text("Name: \(character.name)")
								.font(.largeTitle)
							
							Text("Protrayed by: \(character.portrayedBy)")
								.font(.subheadline)
							
							Divider()
							
							Text("\(character.name) Character Info")
								.font(.title2)
							
							Text("Born: \(character.birthday)")
							
							Divider()
							
							Text("Occupations:")
							
							ForEach(character.occupations, id: \.self) { occupation in
								Text("• \(occupation)")
									.font(.subheadline)
							}
							
							Divider()
							
							Text("Nicknames:")
							
							if !character.aliases.isEmpty {
								ForEach(character.aliases, id: \.self) { alias in
									Text("• \(alias)")
										.font(.subheadline)
								}
							} else {
								Text("None")
									.font(.subheadline)
							}
							
							Divider()
							
							DisclosureGroup("Status (spoiler alert):") {
								VStack(alignment: .leading) {
									Text("Status: \(character.status)")
										.font(.title2)
									
									if let death = character.death {
										AsyncImage(url: death.image) { image in
											image
												.resizable()
												.scaledToFit()
												.clipShape(.rect(cornerRadius: 15))
												.onAppear {
													withAnimation {
														proxy.scrollTo(1, anchor: .bottom)
													}
												}
										} placeholder: {
											ProgressView()
										}
										
										Text("How: \(death.details)")
											.padding(.bottom, 7)
										
										Text("Last words: \"\(death.lastWords)\"")
									}
								}
								.frame(maxWidth: .infinity, alignment: .leading)
							}
							.tint(.primary)
						}
						.frame(width: geo.size.width/1.25, alignment: .leading)
						.padding(.bottom, 50)
						.id(1)
					}
					.scrollIndicators(.hidden)
				}
			}
		}
		.ignoresSafeArea()
    }
}

#Preview {
	CharacterView(character: ViewModel().char, show: Constants.bbName)
}
