//
//  CheckoutPageView.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/11/24.
//

import SwiftUI

struct CheckoutPageView: View {
    let sqlDB = SQLiteViewModel()
    @State var cart: [CartModel] = []
    func getCart() {
        cart = SQLiteViewModel().query()
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(cart) { doughnut in
                    CartItemView(doughnut: doughnut, onItemDeleted: {
                        getCart()
                    })
                }
            }
            .padding(.bottom, 50.0)
            
            VStack {
                Spacer()
                
                Button(action: {
                    print("checking out")
                }, label: {
                    Text("Checkout")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                })
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.blue)
                
            }
            .padding(.bottom, 1)
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
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainView()
}
