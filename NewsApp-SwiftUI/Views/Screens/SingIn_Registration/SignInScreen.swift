//
//  SignInScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 06.10.2022.
//

import SwiftUI
import Firebase

struct SignInScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var errorText: String?
    @State var showError = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                LogoImage()
                RegistrationTextField(text: $email, placeholder: "Email Address", imageName: "envelope.fill")
                    .padding(.horizontal)
                    .padding(.top, 40)
                CustomSecureField(password: $password)
                    .padding(.horizontal)
                    .padding(.top, 30)

                HStack {
                    Spacer()
                    Button {

                    } label: {
                        Text("Forget Password?")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                Button {
                    viewModel.login(withEmail: email, password: password)
//                    Task {
//                        do {
//                            try await viewModel.login(withEmail: email, password: password)
//                        } catch {
//                            self.errorText = "Failed to login: \(error.localizedDescription)"
//                            self.showError.toggle()
//                        }
//                    }
                } label: {
                    ActionButtonView(title: "Login")
                }
                .padding(.top, 30)
                NavigationLink {
                    SignUpScreen()
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
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error Logging in"),
                  message: Text(errorText ?? ""),
                  dismissButton: .default(Text("Ok")))
        }
    }

    func connectToFirebase(email: String, password: String) {
//        AuthService.logUserIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.errorText = error.localizedDescription
//                self.showError.toggle()
//                return
//            }
//
//
//        }
        AuthServicee.instance.logInUserToFirebaseWithEmail(email: email, password: password) { (returnedProviderID, errorDescription, isNewUser, returnedUserID)  in
            if let _ = isNewUser {
//                if newUser {
//                    // NEW USER
//                    if let providerID = returnedProviderID, !isError {
//                        // New user, continue to the onboarding part 2
//                        self.displayName = name
//                        self.email = email
//                        self.providerID = providerID
//                        self.provider = provider
//                        self.showOnboardingPart2.toggle()
//                    } else {
//                        // ERROR
//                        print("Error getting provider ID from log in user to Firebase")
//                        self.showError.toggle()
//                    }
//                } else {
                    // EXISTING USER
                if let errorDescription = errorDescription {
                    self.errorText = errorDescription
                    self.showError.toggle()
                }
                    if let userID = returnedUserID {
                        // SUCCESS, LOG IN TO APP
                        AuthServicee.instance.logInUserToApp(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error logging existing user into our app")
                                self.errorText = "Error logging existing user into our app"
                                self.showError.toggle()
                            }
                        }
                    } else {
                        // ERROR
                        self.errorText = "Error getting USER ID from existing user to Firebase"
                        print("Error getting USER ID from existing user to Firebase")
                        self.showError.toggle()
                    }
//                }
            } else {
//                // ERROR
//                print("Error getting into from log in user to Firebase")
                self.errorText = "Error getting into from log in user to Firebase"
                self.showError.toggle()
            } 
            
        }
        
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
