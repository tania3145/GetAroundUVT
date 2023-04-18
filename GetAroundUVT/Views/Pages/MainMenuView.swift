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
            EventsView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Events", systemImage: "graduationcap")
                }
                .tag(2)
            MapView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(3)
            FriendsView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Friends", systemImage: "person.3")
                }
                .tag(4)
            SettingsView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(5)
        }
    }
}


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
