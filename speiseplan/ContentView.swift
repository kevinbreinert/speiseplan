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
	  
	  // MARK: Header-View
	  HeaderView(test: "Speiseplan")
	  
	  
	  
	  
	  ScrollView(){
		ForEach(rows.prefix(1), id: \.self) { row in
		  VStack {
			ForEach(row.Days , id: \.self) { day in
			  VStack{
				ZStack() {
				  VStack() {
					Rectangle()
					  .fill(Color(red: 0.47843137254901963, green: 0.47843137254901963, blue: 0.47843137254901963))
					  .frame(height: 60)
					  .cornerRadius(10)
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
						
						RowView(row: row, weekday: day.Weekday, products: products, allergens: allergens)
						
					  )
					  .cornerRadius(10)
					  .padding(5.0)
					  .padding(.leading, 5)
					  .padding(.trailing, 5)
					  .padding(.bottom, 10)
					  .foregroundColor(Color(red: 0.28627450980392155, green: 0.28627450980392155, blue: 0.28627450980392155))
					
					
				  }
				}
				
				
			  }
			  .background(Color(red: 0.9607843137254902, green: 0.9607843137254902, blue: 0.9607843137254902))
			  .cornerRadius(10)
			  .padding(5.0)
			  .padding(.leading, 5)
			  .padding(.trailing, 5)
			  .padding(.bottom, 10)
			  .shadow(color: .gray, radius: 2, x: 0, y: 0.5)
			}
		  }
		}
		.onAppear(){
		  fetchData()
	  
			
		  
		}
		.padding(.top, 10)
		
	  }
	  .padding(.bottom, 30)
	}
	.ignoresSafeArea(.all)
	.background(.white)
	
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
	  //.background(Color(hue: 1.0, saturation: 0.0, brightness: 1.0))
  }
}
