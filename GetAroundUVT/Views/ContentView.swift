//
//  ContentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    @State private var map = GoogleMapsService.createGoogleMapsService()
    
    var body: some View {
        ZStack {
            GoogleMapWrapperView(map: $map)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        map.moveCameraToUVT(withAnimation: true)
//                    }, label: {
//                        Image(systemName: "location.fill")
//                            .imageScale(.large)
//                            .frame(width: 60, height: 60)
//                            .foregroundColor(Color.white)
//                    })
//                    .background(Color.blue)
//                    .cornerRadius(38.5)
//                    .padding()
//                    .shadow(color: Color.black.opacity(0.3),
//                            radius: 3,
//                            x: 3,
//                            y: 3)
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
