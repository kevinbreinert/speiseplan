//
//  RowView.swift
//  speiseplan
//
//  Created by Kevin Breinert on 05.09.23.
//

import SwiftUI

struct RowView: View {
  
  var row: Row
  var weekday: Int
  var products: [Product]
  var allergens: [String: Allergen]
  
  var body: some View {
	let ids = row.Days.first{ $0.Weekday == weekday }?.ProductIds.map { $0.ProductId } ?? []
	VStack(spacing: 7){
		Text(row.Name)
		  .font(.headline)
	  
	  
	  
		
			  VStack(spacing: 7) {
				ForEach(ids, id: \.self) { productID in
				  if let product = products.first(where: { $0.ProductId == productID }) {
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
					.padding([.trailing, .leading], 25)
				  }
				}
			  }
	}
  }
}

