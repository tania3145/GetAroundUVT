//
//  SettingsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Text("Settings")
            Spacer()
            Button {
                signOut()
            } label: {
                Text("Logout")
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Exception occurred"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func signOut() {
        do {
            let service = GetAroundUVTBackendService.Instance()
            try service.signOut()
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
