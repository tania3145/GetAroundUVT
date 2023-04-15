//
//  MapView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 14.04.2023.
//

import Foundation
import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct MapViewWrapper: UIViewRepresentable {
    let mapViewModel: MapViewModel
    
    func makeUIView(context: Context) -> UIView {
        mapViewModel.mapView.delegate = context.coordinator
        return mapViewModel.mapView;
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> MapViewModel {
        return mapViewModel
    }
}

struct MapView: View {
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some View {
        MapViewWrapper(mapViewModel: mapViewModel)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        return MapView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
