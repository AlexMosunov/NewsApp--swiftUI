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

    @State var errorText: String?
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
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
                        let userCredentials = UserCredentials(
                            email: email, password: password,
                            repeatPassword: repeatPassword, username: username,
                            fullname: fullname, profileImage: selectedImage
                        )
                        isLoading = true
                        viewModel.registerUser(userCredentials) { errorString in
                            isLoading = false
                            if let errorString = errorString {
                                errorText = errorString
                                showError.toggle()
                                return
                            }
                        }
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
                if isLoading {
                    ProgressView()
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error Signing up"),
                      message: Text(errorText ?? ""),
                      dismissButton: .default(Text("Ok")))
            }
            .frame(maxHeight: .infinity)
            .background(ColorScheme.backgroundColor)
            .navigationBarHidden(true)
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
            .preferredColorScheme(.dark)
    }
}
