//
//  RecCell.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 4/23/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI

struct RecCell: View {
    var rec: Recommendation
    var num: Int
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("\(num).")
                    .font(Font.custom("Prata-regular", size: 20.0))
                    .frame(width: 40)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                
                VStack(spacing: 0) {
                    Text(rec.restaurant.name)
                        .font(Font.custom("Prata-regular", size: 18))
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                    Text(rec.restaurant.cuisines.joined(separator: ", "))
                        .font(Font.custom("Lato-Regular", size: 12))
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Text(rec.restaurant.address)
                        .font(Font.custom("Lato-Regular", size: 12))
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 12)
                }
            }
            
            Rectangle()
                .fill(Color.white)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
