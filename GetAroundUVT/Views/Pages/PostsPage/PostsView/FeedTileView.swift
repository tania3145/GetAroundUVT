//
//  FeedTileView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 24.05.2023.
//

import Foundation
import SwiftUI

struct FeedTileView: View {
    var feedItem: FeedItem
    
    var body: some View{
        VStack {
            HStack{
                avatar
                VStack(alignment: .leading) {
                    Text(feedItem.name)
                        .foregroundColor(.white)
                    //                        .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                        .font(.title3.bold())
                    
                    Text(feedItem.email)
                        .foregroundColor(Color(red: 0.859, green: 0.678, blue: 0.273))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .bold()
                }
                Spacer()
            }
            .padding([.horizontal, .top])
            
            Text(feedItem.body)
                .foregroundColor(.white)
                .foregroundColor(.secondary)
                .padding([.horizontal, .bottom])
            
            if let imageURL = feedItem.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
            }
            
            Spacer()
            Spacer()
            
            if(feedItem.directions) {
                HStack{

                    Text("Location:")
                        .foregroundColor(.white)
                        .font(.title3.bold())

                    Text(feedItem.location)
                        .foregroundColor(.white)

                    Spacer()
                }
            }

            HStack{
                Spacer()
                if(feedItem.directions){
                    Button(action: {
                        
                    }) {
                        Text("Get Directions")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 0.859, green: 0.678, blue: 0.273))
                            .cornerRadius(10)
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
        .cornerRadius(15)
        .shadow(color: Color(red: 0.266, green: 0.436, blue: 0.699).opacity(0.5), radius: 2, x: 10, y: 10)
        
    }
    
    var avatar: some View {
        AsyncImage(url: feedItem.avatarURL) { image in
            image.resizable()
        } placeholder: {
            Color.gray
        }
        .frame(width: 50, height: 50)
        .cornerRadius(25)
    }
}
    
    
    
struct FeedTileView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(feed: [.demo1, .demo2, .demo3, .demo4])
        //        FeedTileView()
    }
}
