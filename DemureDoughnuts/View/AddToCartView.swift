//
//  AddToCartView.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/11/24.
//

import SwiftUI

struct AddToCartView: View {
    @Environment(\.dismiss) var dismiss
    let donut: DonutsModel
    let sqlDB = SQLiteViewModel()
    @State var quantity: Int = 1
    
    func seeData() {
        print(donut.name)
    }
    
    var body: some View {
        ScrollView {
            VStack {
//                    HStack {
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            Image(systemName: "multiply")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 20, height: 20)
//                                .foregroundColor(.black)
//                        }
//                        
//                        Spacer()
//                    }
                    
                    HStack {
                        Text(donut.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.top, 25)
                    
                    HStack {
                        Text("$\(String(format: "%.2f", donut.cost * Double(quantity)))")
                        
                        
                        Spacer()
                    }
                    
                    AsyncImage(url: URL(string: donut.image)) { image in
                        image
                        //                        .resizable()
                        //                        .aspectRatio(contentMode: .fit)
                        //                        .frame(width: 70)
                    } placeholder: {
                        ProgressView()
                    }
                
                HStack {
                    HStack {
                        Button(action: {
                            if quantity != 1 {
                                quantity -= 1
                            }
                        }, label: {
                            Image(systemName: "minus")
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Text("\(quantity)")
//                            .background(.red)
                        Spacer()
                        Button(action: {
                            quantity += 1
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        })
                    }
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
//                    .background(.red)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1) // Black border with rounded corners
                    )
                    
                    
                    Button(action: {
                        sqlDB.isInCart(donut: donut, quantity: quantity)
                        print("Added to cart.")
                        dismiss()
                    }, label: {
                        Text("Add to Bag")
                            .padding(.all, 10)
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    })
                    

                }
//                .background(.red)
            }
            .padding(.horizontal, 25.0)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            seeData()
        }
    }
}

#Preview {
    AddToCartView(donut: DonutsModel(cost: 9.99, image: "https://firebasestorage.googleapis.com/v0/b/flashchat-76c44.appspot.com/o/blueberry-cake-doughnut-icon.png?alt=media&token=c1ce61fd-f8d3-4a23-bc10-dc8fa98d9e3d", name: "Donuts Magee", type: "plain"))
}
