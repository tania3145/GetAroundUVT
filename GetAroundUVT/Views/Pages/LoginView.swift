//
//  LoginView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct LoginView: View {
    @State var navigateToMainMenu : Bool = false
    @State var navigateToRegister : Bool = false
    
    @ViewBuilder
    var body: some View {
        ZStack {
            if navigateToMainMenu || navigateToRegister {
                VStack {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                }
            } else {
                VStack {
                    Text("Login stuff")
                    Spacer()
                    Button {
                        // Code here before changing the bool value
                        navigateToRegister = true
                    } label: {
                        Text("Go to Register")
                    }
                    Spacer()
                    Button {
                        // Code here before changing the bool value
                        navigateToMainMenu = true
                    } label: {
                        Text("Go to Main Menu")
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateToRegister) {
            RegisterView()
            //                    .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $navigateToMainMenu) {
            MainMenuView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
