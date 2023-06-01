//
//  SettingsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct AccountView: View {
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        ZStack{
//            Color(red: 0.115, green: 0.287, blue: 0.448).edgesIgnoringSafeArea(.all)
            VStack {
                VStack(){
                    Image("Profile")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    Text("Curuțchi Tania-Maria")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
                }
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Image(systemName: "envelope")
                            .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                        Text("tania.curutchi01@e-uvt.ro")
                            .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
                    }
                    
                    HStack{
                        Image(systemName: "phone")
                            .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                        Text("0758385179")
                            .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
                    }
                    
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Exception occurred"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func signOut() {
        do {
            let service = FirebaseService.Instance()
            try service.signOut()
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
