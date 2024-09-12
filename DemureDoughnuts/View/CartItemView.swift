//
//  CartItemView.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/12/24.
//

import SwiftUI

struct CartItemView: View {
    let doughnut: CartModel
    let sqlDB = SQLiteViewModel()
    @State var quantity: Int = 0
    @State var cost: Double = 0
    @State var totalCost: Double = 0
    var onItemDeleted: () -> Void
    func getQuantity() {
        quantity = doughnut.quantity
        cost = doughnut.cost
        totalCost = Double(doughnut.quantity) * doughnut.cost
    }
    func getTotalCost() {
        totalCost = Double(quantity) * cost
    }
    
    var body: some View {
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
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                    Text("$\(String(format: "%.2f", totalCost))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
            }
            
            HStack {
                HStack {
                    Button(action: {
                        if quantity != 1 {
                            quantity -= 1
                            getTotalCost()
                            sqlDB.update(donut: doughnut, function: "subtract")
                        } else {
                            sqlDB.delete(donut: doughnut)
                            onItemDeleted()
                        }
                    }, label: {
                        if quantity > 1 {
                            Image(systemName: "minus")
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.black)
                        }
                    })
                    Spacer()
                    Text("\(quantity)")
                    //                            .background(.red)
                    Spacer()
                    Button(action: {
                        quantity += 1
                        getTotalCost()
                        sqlDB.update(donut: doughnut, function: "add")
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    })
                }
                .padding(.all, 10)
                .frame(maxWidth: 100)
                //                    .background(.red)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1) // Black border with rounded corners
                )
                
//                Button(action: {
//                    print("delete item")
//                }, label: {
//                    Text("Remove")
//                        .padding(.all, 10)
//                        .frame(maxWidth: .infinity)
//                        .background(.blue)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                })
            }
        }
        .onAppear {
            getQuantity()
        }
        .padding(.horizontal, 25)
    }
}


#Preview {
    HomePageView()
}
