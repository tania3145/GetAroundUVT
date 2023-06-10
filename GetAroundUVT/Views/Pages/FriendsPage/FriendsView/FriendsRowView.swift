//
//  FriendsRowView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 08.06.2023.
//

import Foundation
import SwiftUI

struct FriendsRowView: View {
    var personItem: Person

    var body: some View{
        HStack{
            if let imageURL = personItem.image {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                } placeholder: {
                    Color.gray
                }
            }
            VStack (alignment: .leading, spacing: 10){
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(personItem.firstName) \(personItem.lastName)")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448))

                    Text(personItem.email)
                        .fontWeight(.regular)
                        .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                }.layoutPriority(1)
                
                
                HStack{
                    Button(action: {
                        
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
                    
                    Button(action: {
                        
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
}

struct FriendsRowView_Preview: PreviewProvider {
    static var previews: some View {
        FriendsContentView(person: [.person1, .person2])
    }
}


//Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
//                                                .fill(Color(red: 0.859, green: 0.678, blue: 0.273)) // Yellow UVT Color

