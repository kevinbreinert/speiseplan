//
//  ContentView.swift
//  speiseplan
//
//  Created by Kevin Breinert on 28.08.23.
//

import SwiftUI

struct Allergen: Codable {
	let Id: String
	let Label: String
}

struct ProductId: Codable, Hashable {
	let ProductId: Int
}

struct Day: Codable, Hashable{
	let Weekday: Int
	let ProductIds: [ProductId]
}

struct Row: Codable, Hashable{
	let Name: String
	let Days: [Day]
}

struct Price: Codable {
	let Betrag: Double
}

struct Product: Codable {
	let AllergenIds: [String]
	let ProductId: Int
	let Name: String
	let Price: Price
}

struct MenuData: Codable {
	let Allergens: [String: Allergen]
	let Products: [String: Product]
	let Rows: [Row]
	
}



struct ContentView: View {
	@State var products: [Product] = []
	@State var rows: [Row] = []
	@State private var allergens: [String: Allergen] = [:]
	@State private var menuData: MenuData?
	
	var body: some View {
		VStack(spacing: 0){
			Rectangle()
				.fill(Color(red: 0.42745098039215684, green: 0.8705882352941177, blue: 0.6313725490196078, opacity: 1))
				.frame(height: 110)
				.overlay(
					HStack{
						Text("Speiseplan")
							.font(.system(size: 28))
						
							.fontWeight(.medium)
							.foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.207))
						
							.padding(.top, 50) // Verschieben des Textes nach unten
							.padding(.leading, 15) // Verschieben des Textes nach links
						
						Spacer()
					}
					
				)
				.padding(.bottom, 0)
				.foregroundColor(.white)
			
			
			ScrollView(){
				
				ForEach(rows.prefix(1), id: \.self) { row in
					VStack {
						ForEach(row.Days , id: \.self) { day in
							VStack{
								
								
								ZStack() {
									
									Color.gray.opacity(0)
										.cornerRadius(10)
									
									VStack(spacing: 3) {
										Rectangle()
											.fill(Color(red: 0.47843137254901963, green: 0.47843137254901963, blue: 0.47843137254901963))
											.frame(height: 60)
											.overlay(
												VStack {
													Group {
														switch day.Weekday {
														case 0:
															Text("Montag")
															
														case 1:
															Text("Dienstag")
														case 2:
															Text("Mittwoch")
														case 3:
															Text("Donnerstag")
														case 4:
															Text("Freitag")
														default:
															Text("")
														}
														
													}
												}
											)
									}
									// VStack
									.padding(.bottom, 5.0)
									.cornerRadius(10)
									.font(.headline)
									.foregroundColor(.white)
								}
								
								
								ForEach(rows, id: \.self) { row in
									VStack(spacing:0){
										
										Rectangle()
											.fill(Color(red: 0.8862745098039215, green: 0.8862745098039215, blue: 0.8862745098039215))
											.frame(height: 97)
											.overlay(
												
												VStack(spacing: 7){
													Group{
														Text(row.Name)
															.font(.headline)
														ForEach(0..<row.Days.count, id: \.self) { countOfDays in
															if day.Weekday == countOfDays {
																if let thirdDay = row.Days.dropFirst(countOfDays).first {
																	VStack(spacing: 7) {
																		ForEach(thirdDay.ProductIds, id: \.ProductId) { productID in
																			if let product = products.first(where: { $0.ProductId == productID.ProductId }) {
																				Text(product.Name)
																				HStack{
																					ForEach(product.AllergenIds, id: \.self) { allergenId in
																						if let allergen = allergens[allergenId] {
																							Text("\(allergen.Label)")
																							
																						}
																					}
																					Spacer()
																					Text("\(String(format: "%.2f", product.Price.Betrag))€")
																				}
																				.padding(.trailing, 25)
																				.padding(.leading, 25)
																			}
																		}
																	}
																}
															}
															
														}
													}
												}
												
											)
											.cornerRadius(10)
											.padding(5.0)
											.padding(.leading, 5)
											.padding(.trailing, 5)
											.padding(.bottom, 10)
											.foregroundColor(Color(red: 0.28627450980392155, green: 0.28627450980392155, blue: 0.28627450980392155))
										
										
									}
								} //foreach show aktion
								
								
							}
							.background(Color(red: 0.9607843137254902, green: 0.9607843137254902, blue: 0.9607843137254902))
							.cornerRadius(10)
							.padding(5.0)
							.padding(.leading, 5)
							.padding(.trailing, 5)
							.padding(.bottom, 10)
						}//Foreach row.days
					}
					// Vstack under foreach and scrollview
				}
				//Foreach first
				.onAppear(){
					fetchData()
					
				}
				.padding(.top, 10)
				
			}
			.padding(.bottom, 30)
			// Scrollview
			
		}
		.ignoresSafeArea(.all)
		
	}
	func fetchData() {
		let apiUrlString = "https://my.qnips.io/dbapi/ha"
		
		if let apiUrl = URL(string: apiUrlString) {
			var request = URLRequest(url: apiUrl)
			request.setValue("application/json", forHTTPHeaderField: "Accept")
			
			let session = URLSession.shared
			let task = session.dataTask(with: request) { data, response, error in
				if let error = error {
					print("Fehler: \(error)")
					return
				}
				
				if let data = data {
					do {
						let decoder = JSONDecoder()
						decoder.keyDecodingStrategy = .convertFromSnakeCase
						let productsContainer = try decoder.decode(MenuData.self, from: data)
						
						
						DispatchQueue.main.async {
							self.products = Array(productsContainer.Products.values)
							self.allergens = productsContainer.Allergens
							self.rows = Array(productsContainer.Rows)
						}
					} catch {
						print("Fehler beim Decodieren der JSON-Daten: \(error)")
					}
				}
			}
			
			task.resume()
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.background(Color(hue: 1.0, saturation: 0.0, brightness: 1.0))
	}
}
