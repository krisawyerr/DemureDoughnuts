//
//  MainView.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/10/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView() {
            HomePageView()
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("Order")
                }
            ProfilePageView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainView()
}
