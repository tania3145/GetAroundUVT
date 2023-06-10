//
//  FriendsRowView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 08.06.2023.
//

import Foundation
import SwiftUI
import GoogleMaps

struct FriendsRowView: View {
    @Binding var tabSelection: Int
    @StateObject var mapViewModel: MapViewModel
    @StateObject var friendsViewModel: FriendsViewModel
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Exception occurred"
    @State var alertMessage: String = ""
    var personItem: Person

    var body: some View {
        HStack{
//            if let imageURL = personItem.image {
//                AsyncImage(url: imageURL) { image in
//                    image
//                        .resizable()
            FirebaseUserProfileImage(id: personItem.id)
                .aspectRatio(contentMode: .fill)
                .clipped()
                .clipShape(Circle())
                .frame(width: 80, height: 80)
//                }
//                placeholder: {
//                    Color.gray
//                }
//            }
            VStack (alignment: .leading, spacing: 10){
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(personItem.name)")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))

                    Text(personItem.email)
                        .fontWeight(.regular)
                        .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                }.layoutPriority(1)
                
                
                HStack{
                    if !friendsViewModel.isFriend(person: personItem) {
                        Button(action: {
                            DispatchQueue.main.async {
                                Task {
                                    do {
                                        try await addFriend()
                                    } catch {
                                        showAlert = true
                                        alertMessage = "\(error)"
                                    }
                                }
                            }
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 35)
                                    .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))
                                Text("Add Friend")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                            
                        }
                    } else if personItem.location != nil {
                        Button(action: {
                            DispatchQueue.main.async {
                                Task {
                                    do {
                                        try await getDirections()
                                    } catch {
                                        showAlert = true
                                        alertMessage = "\(error)"
                                    }
                                }
                            }
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 35)
                                    .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                                Text("Get Directions")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
            
            //        .edgesIgnoringSafeArea(.top)
            //        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
        }
    }
    
    func getDirections() async throws {
        tabSelection = 3
        _ = try await mapViewModel.goToFriend(friend: personItem)
    }
    
    func addFriend() async throws {
        try await friendsViewModel.addFriend(personItem: personItem)
    }
}

struct FriendsRowView_Preview: PreviewProvider {
    static var previews: some View {
        FriendsContentView(tabSelection: .constant(1), mapViewModel: MapViewModel())
    }
}


//Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
//                                                .fill(Color(red: 0.859, green: 0.678, blue: 0.273)) // Yellow UVT Color

