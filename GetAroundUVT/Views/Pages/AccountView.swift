//
//  SettingsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct AccountView: View {
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Exception occurred"
    @State var alertMessage: String = ""
    @State var user: FirebaseUser? = nil
    
    var body: some View {
        ZStack{
//            Color(red: 0.115, green: 0.287, blue: 0.448).edgesIgnoringSafeArea(.all)
            VStack {
                VStack() {
                    FirebaseUserProfileImage()
//                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    Text(user?.name ?? "Name")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
                }
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Image(systemName: "envelope")
                            .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                        Text(user?.email ?? "Email")
                            .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
                    }
                    
//                    HStack{
//                        Image(systemName: "phone")
//                            .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
//                        Text("0758385179")
//                            .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
//                    }
                    
                    // add more fileds here
                }
                Spacer().frame(height: 30)
                
                Button {
                    signOut()
                } label: {
                    Text("Logout")
                        .font(.title2)
                        .bold()
                        .frame(width: 260, height: 70)
                        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear() {
            let service = FirebaseService.Instance()
            DispatchQueue.main.async {
                Task {
                    do {
                        user = try await service.getCurrentUserData()
                    } catch {
                        showAlert = true
                        alertMessage = "\(error)"
                    }
                }
            }
        }
    }
    
    private func signOut() {
        do {
            let service = FirebaseService.Instance()
            try service.signOut()
        } catch {
            showAlert = true
            alertMessage = error.localizedDescription
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
