//
//  MainMenuView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject var mapViewModel = MapViewModel()
    @State private var tabSelection = 3
    
    var body: some View {
        TabView(selection: $tabSelection) {
            CalendarView(tabSelection: $tabSelection, mapViewModel: mapViewModel)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
            FriendsView(tabSelection: $tabSelection, mapViewModel: mapViewModel)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("People", systemImage: "person.3")
                }
                .tag(2)
            MapView(mapViewModel: mapViewModel)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(3)

            PostsView(tabSelection: $tabSelection, mapViewModel: mapViewModel)
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
