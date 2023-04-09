//
//  GoogleMapsService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils

class GoogleMapsService {
    public let mapView: GMSMapView
    
    private let uvtLocation = CLLocationCoordinate2D(latitude: 45.74717, longitude: 21.23105)
    private let uvtZoomLevel: Float = 17
    
    private init(mapView: GMSMapView) {
        self.mapView = mapView
        loadUVTAssets()
        moveCameraToUVT()
    }
    
    public func moveCameraToUVT(withAnimation: Bool = false) {
        let camera = GMSCameraPosition(
            latitude: uvtLocation.latitude,
            longitude: uvtLocation.longitude,
            zoom: uvtZoomLevel)
        
        if withAnimation {
            let uvtCam = GMSCameraUpdate.setCamera(camera)
            mapView.animate(with: uvtCam)
        } else {
            mapView.camera = camera
        }
    }
    
    private func loadUVTAssets() {
        guard let path = Bundle.main.path(forResource: "UVTData", ofType: "json") else {
            print("Couldn't find UVTData overlay.")
            return
        }
        
        let url = URL(fileURLWithPath: path)

            let geoJsonParser = GMUGeoJSONParser(url: url)
            geoJsonParser.parse()

            let renderer = GMUGeometryRenderer(map: mapView, geometries: geoJsonParser.features)
            renderer.render()
    }
    
    static func createGoogleMapsService() -> GoogleMapsService {
        GMSServices.provideAPIKey("AIzaSyBvpb75co2ehXH-qG420MrwPhhZbmqJRVM")
        let map = GMSMapView()
        return GoogleMapsService(mapView: map);
    }
}
