//
//  ProfileScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI
import Firebase

struct ProfileScreen: View {
    @State var selectedImage: UIImage?
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ProfileHeaderView(selectedImage: $selectedImage)
                ProfileSettingsView()
            }
            .navigationTitle(Localized.tabview_profile)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
