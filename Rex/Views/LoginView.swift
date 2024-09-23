//
//  LoginView.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import SwiftUI


struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                VStack {
                    HStack{
                        Image("Login")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .offset(x: -10)
                        Text("rex")
                            .font(.system(size: 50))
                            .bold()
                            .foregroundColor(Color("TextColor"))
                            .offset(x: -30)

                    }
                    Text("all your favorites in one place")
                        .font(.system(size: 16))
                        .offset(y: -30)

                }
                .padding(.top, 100)
                List {
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password).textFieldStyle(DefaultTextFieldStyle())
 
                }
                .scrollContentBackground(.hidden)
                Button("Log In"){
                    viewModel.login()}
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .background(Color("FunColor"))
                .cornerRadius(25)
                .offset(y:-50)
                //Create Account
                VStack {
                    Text("New here?")
                    NavigationLink("Create An Account", destination: RegisterView())
                        .bold()
                }
                .padding(.bottom, 50)
                Spacer()
            }
            .background{Color("MainColor")                .ignoresSafeArea()}
        }

    }
}


#Preview {
    LoginView()
}
