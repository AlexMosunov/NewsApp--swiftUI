//
//  OnboardingViewPart2.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct OnboardingViewPart2: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var displayName: String = ""
    @State var showImagePicker: Bool = false
    
    // For image picker
    @State var imageSelected: UIImage? = UIImage(named: "avatar")
//    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            AvatarImage(selectedImage: $imageSelected)
            Text("What's your name?")
                .font(.title3)
                .fontWeight(.bold)
//                .foregroundColor(Color.MyTheme.yellowColor)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
//                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
//                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            })
//            .accentColor(Color.MyTheme.purpleColor)
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeOut, value: 1.0)
//            .animation(.easeOut(duration: 1.0))
            
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker, onDismiss: createProfile, content: {
            ImagePicker(image: $imageSelected)
        })
        
    }
    
    // MARK: FUNCTIONS
    
    func createProfile() {
        print("CREATE PROFILE NOW")
    }
    
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewPart2()
            
    }
}
