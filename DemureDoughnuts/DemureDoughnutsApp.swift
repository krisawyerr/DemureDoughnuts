//
//  DemureDoughnutsApp.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/10/24.
//

import SwiftUI
import FirebaseCore

@main
struct DemureDoughnutsApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
