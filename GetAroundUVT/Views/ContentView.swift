//
//  ContentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State var mapController = MapController()
    
    var body: some View {
        mapController.attachView(mapComponentView: MapComponentView(mapController: $mapController))
        return ZStack {
            mapController.view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        mapController.view.mapRenderer.moveCameraTo(MapRenderer.UVT_LOCATION, withAnimation: true)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
