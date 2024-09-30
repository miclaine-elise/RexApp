//
//  RegisterView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @ObservedObject var keyboardResponder: KeyboardResponder


    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if keyboardResponder.currentHeight == 0 {
                        Image("Login")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    Text("welcome to rex")
                        .font(.system(size:  keyboardResponder.currentHeight == 0 ? 30 : 20))
                        .bold()
                        .foregroundColor(Color("TextColor"))
                        //.padding()
                    
                }
                .padding(.top, keyboardResponder.currentHeight == 0 ? 50 : 0)
                
                VStack {
                    List {
                        Section {
                            TextField("First Name", text: $viewModel.firstName)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                            
                            TextField("Last Name", text: $viewModel.lastName)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                            
                            TextField("Nickname", text: $viewModel.nickname)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                        }
                        
                        Section {
                            TextField("Email Address", text: $viewModel.email)
                                .textFieldStyle (DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                            
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(DefaultTextFieldStyle())
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 300)
                    if keyboardResponder.currentHeight == 0 {
                        Spacer()
                    }
                    Button("Create Account") {
                        viewModel.register()
                    }
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("FunColor"))
                    .cornerRadius(25)
                }
                .padding(.top, 0)
                .padding(.horizontal)
                .padding(.bottom, keyboardResponder.currentHeight == 0 ? 40 : 0)  // Adjust for keyboard height
                if keyboardResponder.currentHeight != 0 {
                    Spacer()
                }
            }
            .onTapGesture {
                self.hideKeyboard()
        }

            .background {
                Color("MainColor").ignoresSafeArea()
            }
        }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Registration Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}


//#Preview {
//    RegisterView()
//}




