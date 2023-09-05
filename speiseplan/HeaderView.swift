//
//  HeaderView.swift
//  speiseplan
//
//  Created by Kevin Breinert on 05.09.23.
//

import SwiftUI

struct HeaderView: View {
  let test: String
  var body: some View {
	  
	  // MARK: Header-View
	  Rectangle()
		.fill(Color(red: 0.42745098039215684, green: 0.8705882352941177, blue: 0.6313725490196078, opacity: 1))
		.frame(height: 110)
		.overlay(
		  HStack{
			Text(test)
			  .font(.system(size: 28))
			  .fontWeight(.medium)
			  .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.207))
			  .padding(.top, 50)
			  .padding(.leading, 15)
			
			Spacer()
		  }
		)
		.padding(.bottom, 0)
		.foregroundColor(.white)
	}
  }

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(test: "Speiseplan")
    }
}
