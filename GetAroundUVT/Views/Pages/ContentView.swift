//
//  ContentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    @State private var requireLogin: Bool = true
    
    var body: some View {
        registerSignInState()
        return NavigationStack {
            if requireLogin {
                LoginSignupView()
            } else {
                MainMenuView()
            }
        }
    }
    
    private func registerSignInState() {
        let service = FirebaseService.Instance()
        service.addAuthListener { loggedIn in
            print(loggedIn)
            requireLogin = !loggedIn
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
