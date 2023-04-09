//
//  GoogleMapWrapperView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import SwiftUI

struct GoogleMapWrapperView: UIViewRepresentable {
    
    @Binding public var map: GoogleMapsService
    
    func makeUIView(context: Context) -> UIView {
        return map.mapView;
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
