//
//  SettingsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @State var navigateToLogin : Bool = false
    
    var body: some View {
        VStack {
            Text("Settings")
            Spacer()
            Button {
                // Code here before changing the bool value
                navigateToLogin = true
            } label: {
                Text("Go to Login")
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginSignupView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
