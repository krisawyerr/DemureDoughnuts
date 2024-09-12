//
//  ContentView.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/10/24.
//

import SwiftUI

struct HomePageView: View {
    @StateObject private var viewModel = FirestoreViewModel()
    var sortedCategories: [CategoriesModel] {
        viewModel.categories.sorted { $0.id < $1.id }
    }
    let sqlDB = SQLiteViewModel()
    @State var cart: [CartModel] = []
    func getCart() {
        cart = SQLiteViewModel().query()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(sortedCategories) { category in
                        NavigationLink(destination: DoughnutsPageView(category: category.name)) {
                            HStack {
                                HStack {
                                    AsyncImage(url: URL(string: category.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 70)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Text(category.name.capitalized)
                                        .fontWeight(.heavy)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 10.0)
                            .padding(.horizontal, 15.0)
                        }
                    }
                }
            }
            .onAppear {
                getCart()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("DemureText")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 35)
                        .padding(.vertical, 5)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CheckoutPageView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                            Text("\(cart.count)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainView()
}
