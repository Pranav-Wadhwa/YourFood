//
//  HeaderCell.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/31/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI

struct HeaderCell: View {
    @State var headerText: String
    var body: some View {
        Text(headerText)
            .font(Font.custom("Prata-Regular", size: 18))
            .multilineTextAlignment(.center)
            .listRowBackground(Color.clear)
            .foregroundColor(Color.white)
            .padding(.top, 16)
    }
}

struct BodyTextCell: View {
    @State var bodyText: String
    var body: some View {
        Text(bodyText)
            .font(Font.custom("Lato-Regular", size: 14))
            .multilineTextAlignment(.center)
            .foregroundColor(Color.white)
            .padding(.top, 8)
            .padding(.horizontal, 16)
    }
}

struct OptionCell: View {
    @State var text: String
    var isActive: Bool = false
    var body: some View {
        HStack {
            Text(text)
                .font(Font.custom("Prata-Regular", size: 20))
                .foregroundColor(Color.white)
                .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
                        
            Image(systemName: "chevron.up")
                .font(Font.system(size: 20))
                .foregroundColor(Color.white)
                .rotation3DEffect(self.isActive ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(10), y: CGFloat(0), z: CGFloat(0)))
                .animation(.default)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
        .background(Color("Charcoal"))
        
    }
}

struct HeaderCell_Previews: PreviewProvider {
    static var previews: some View {
        HeaderCell(headerText: "Hello World!")
    }
}

struct BodyTextCell_Previews: PreviewProvider {
    static var previews: some View {
        BodyTextCell(bodyText: "Sample text to test the body text cell")
    }
}

