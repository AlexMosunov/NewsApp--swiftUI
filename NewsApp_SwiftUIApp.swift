//
//  NewsApp_SwiftUIApp.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import SwiftUI
import Firebase
//import GoogleSignIn

@main
struct NewsApp_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
//            if Auth.
//            if Auth.auth().currentUser == nil {
//                SignInScreen()
//            } else {
            MainTabView()
                .environmentObject(AuthViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
        }
    }
}
