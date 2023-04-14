//
//  GetAroundUVTApp.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import SwiftUI
import GoogleMaps

@main
struct GetAroundUVTApp: App {
    var body: some Scene {
        GMSServices.provideAPIKey("AIzaSyBvpb75co2ehXH-qG420MrwPhhZbmqJRVM")
        return WindowGroup {
            ContentView()
        }
    }
}
