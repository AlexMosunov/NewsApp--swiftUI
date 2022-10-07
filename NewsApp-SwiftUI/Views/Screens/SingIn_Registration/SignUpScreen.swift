//
//  SignUpScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct SignUpScreen: View {
    @State var selectedImage: UIImage?
    @State var showImagePicker: Bool = false
    @State var email: String = ""
    @State var username: String = ""
    @State var fullname: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""

    @State var showError: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                AvatarImage(selectedImage: $selectedImage)
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
                RegistrationTextField(text: $email, placeholder: "Email Address", imageName: "envelope.fill")
                .padding(.horizontal)
                .padding(.top, 40)
                RegistrationTextField(text: $fullname, placeholder: "Fullname", imageName: "person.crop.rectangle")
                .padding(.horizontal)
                .padding(.top, 30)
                RegistrationTextField(text: $username, placeholder: "Username", imageName: "person.crop.rectangle")
                .padding(.horizontal)
                .padding(.top, 30)
                CustomSecureField(password: $password)
                .padding(.horizontal)
                .padding(.top, 30)
                CustomSecureField(password: $repeatPassword)
                .padding(.horizontal)
                .padding(.top, 30)
                Button {
//                    let credentials = AuthCredentials(
//                        email: email, password: password,
//                        fullname: fullname, username: username,
//                        profileImage: selectedImage ?? UIImage(named: "avatar")!
//                    )
                    viewModel.registerUser(
                        email: email, password: password,
                        repeatPassword: repeatPassword, username: username,
                        fullname: fullname, profileImage: selectedImage
                    )
                } label: {
                    ActionButtonView(title: "Sign Up")
                }
                .padding(.top, 30)
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Sign Up?")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.orange)
                        .underline(true, color: .orange)
                }
                .padding(.top, 10)
            }
            .frame(maxHeight: .infinity)
            .background(ColorScheme.backgroundColor)
            .navigationBarHidden(true)
//            .alert(Text ("Error signing up"), isPresented: $showError)
        }
    }

    func createProfile() {
        print("CREATE PROFILE NOW")
        AuthServicee.instance.createNewUserInDatabase(name: username, email: email, profileImage: selectedImage!) { (returnedUserID) in
            
            if let userID = returnedUserID {
                // SUCCESS
                print("Successfully created new user in database.")
                
                AuthServicee.instance.logInUserToApp(userID: userID) { (success) in
                    if success {
                        print("User logged in!")
                        // return to app
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                        
                    } else {
                        print("Error logging in")
                        self.showError.toggle()
                    }
                }
            } else {
                // ERROR
                print("Error creating user in Database")
                self.showError.toggle()
            }
            
        }
        
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
            .preferredColorScheme(.dark)
    }
}
