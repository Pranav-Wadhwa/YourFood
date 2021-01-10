//
//  RecDisplayView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 4/23/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI
import SafariServices

struct RecDisplayView: View {

    var results: [Recommendation]
    var restaurants: [ZRestaurant] {
        get {
            return results.map( { $0.restaurant })
        }
    }
    @State var selectedId: String = ""
    @State var showDetails: Bool = false
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 1)
                        
            List {
                ForEach(0..<results.count, id: \.self) { i in
                    
                    Button(action: {
                        self.selectedId = self.results[i].id
                        self.showDetails  = true
                    }) {
                        RecCell(rec: self.results[i], num: i + 1)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
            }
        
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .navigationBarTitle("Your  Recommendations")
        .background(Color("Charcoal").edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showDetails) {
            SafariView(url: URL(string: "http://zoma.to/r/" + self.selectedId)!)
        }
    
    }
}

struct RecDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        RecDisplayView(results: [])
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}
