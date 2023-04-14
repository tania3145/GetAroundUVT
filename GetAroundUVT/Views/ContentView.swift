//
//  ContentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import os
import SwiftUI

struct ContentView: View {
    @State var loadPreview: Bool = false
    @State var mapRenderer = MapRenderer()
    @State private var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "ContentView"
    )
    
    init(loadPreview: Bool) {
        self.loadPreview = loadPreview
    }
    
    var body: some View {
        let mapController = MapController(mapRenderer: mapRenderer)
        Task {
            do {
                if (!loadPreview) {
                    try await mapController.loadMetadata()
                }
            } catch {
                logger.error("ERROR ENCOUNTERED: \(error)")
            }
        }
        return TabView {
            Group {
                ZStack {
                    MapComponentView(mapRenderer: $mapRenderer)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                mapController.renderer.moveCameraTo(MapRenderer.UVT_LOCATION, withAnimation: true)
                            }, label: {
                                Image(systemName: "location.fill")
                                    .imageScale(.large)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color.white)
                            })
                            .background(Color.blue)
                            .cornerRadius(38.5)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3),
                                    radius: 3,
                                    x: 3,
                                    y: 3)
                        }
                    }
                }.background(.white)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    Text("Friends Screen")
                }.background(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Label("Friends", systemImage: "person")
                    }
                
                VStack {
                    Text("Nearby Screen")
                }.background(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Label("Nearby", systemImage: "mappin.circle")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(loadPreview: true)
    }
}
