//
//  MainMenuView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct MainMenuView: View {
    @State private var tabSelection = 3
    
    var body: some View {
        TabView(selection: $tabSelection) {
            CalendarView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
            FriendsView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Friends", systemImage: "person.3")
                }
                .tag(2)
            MapView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(3)

            PostsView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Posts", systemImage: "graduationcap")
                }
                .tag(4)
            AccountView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("My Account", systemImage: "person")
                }
                .tag(5)
        }
        .accentColor(Color(red: 0.859, green: 0.678, blue: 0.273))
//        .accentColor(Color(red: 0.115, green: 0.287, blue: 0.448))
    }
}


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
