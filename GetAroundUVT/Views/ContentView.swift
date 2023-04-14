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
    @State private var searchText = ""

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
                        SearchBar(text: $searchText)
                            .padding(.top, 50)
                            .shadow(color: Color.gray, radius: 10, x: 5, y: 5)
                            Spacer()
                    }
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
                }.background(Color.white)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .edgesIgnoringSafeArea(.top)

                VStack {
                    Text("Friends Screen")
                }.background(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Label("Friends", systemImage: "person")
                    }

                VStack {
                    Text("Nearby Screen")
                }.background(Color.white)
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

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("", text: $text)
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.trailing, 8)
                .overlay(
                    Text("Search")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                        .padding(.trailing, 2)
                        .opacity(100)
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
