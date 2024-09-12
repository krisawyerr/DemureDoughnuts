//
//  DoughnutsPageView.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/11/24.
//
import SwiftUI

struct DoughnutsPageView: View {
    @State private var isFullScreenModalPresented = false
    @State private var selectedDoughnut: DonutsModel? = nil
    let category: String
    @StateObject private var viewModel = FirestoreViewModel()
    var sortedDoughnuts: [DonutsModel] {
        viewModel.donuts.filter { $0.type == category }
    }
    let sqlDB = SQLiteViewModel()
    @State var cart: [CartModel] = []
    
    func getCart() {
        cart = SQLiteViewModel().query()
    }
    
    var body: some View {
        ScrollView {
            ForEach(sortedDoughnuts) { doughnut in
                ZStack {
                    HStack {
                        HStack {
                            AsyncImage(url: URL(string: doughnut.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            VStack {
                                Text(doughnut.name.capitalized)
                                    .fontWeight(.heavy)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.black)
                                Text("$\(String(format: "%.2f", doughnut.cost))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.vertical, 10.0)
                    .padding(.horizontal, 15.0)

                    // Button action for each individual doughnut
                    Button(action: {
                        selectedDoughnut = doughnut
                        isFullScreenModalPresented = true
                    }) {
                        Color.clear
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                }
            }
        }
        .onAppear {
            getCart()
        }
        .sheet(item: $selectedDoughnut) { doughnut in
            AddToCartView(donut: doughnut)
                .presentationDetents([.height(550)]) // Customize modal height
                .onDisappear {
                    getCart()
                }
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


#Preview {
    MainView()
}
