//
//  RegisterView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()

    var body: some View {
        VStack {
            Image("Login")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text("welcome to rex")
                .font(.system(size: 30))
                .bold()
                .foregroundColor(Color("TextColor"))
                .padding()
                .offset(y: 100)

            Form {
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
            .offset(y: 100)
            .scrollContentBackground(.hidden)

            Form {
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
            }
            .scrollContentBackground(.hidden)

            Button("Create Account") {
                viewModel.register()
            }
            .bold()
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding()
            .background(Color("FunColor"))
            .cornerRadius(25)
            .offset(y: -50)
        }
        .background { Color("MainColor").ignoresSafeArea() }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Registration Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    RegisterView()
}
