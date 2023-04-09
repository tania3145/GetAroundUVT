//
//  GoogleMapsService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import GameplayKit

class GoogleMapsService {
    public let mapView: GMSMapView
    
    private let navService = IndoorNavigationService()
    private let uvtLocation = CLLocationCoordinate2D(latitude: 45.74717, longitude: 21.23105)
    private let uvtZoomLevel: Float = 17.5
    
    private init(mapView: GMSMapView) {
        self.mapView = mapView
        loadUVTAssets()
        moveCameraToUVT()
        
        // Test
        drawPolyLine(color: .red, points:
            IndoorNavigationService.to(SIMD2<Float>(4, 4)),
            IndoorNavigationService.to(SIMD2<Float>(4, 6)),
            IndoorNavigationService.to(SIMD2<Float>(6, 6)),
            IndoorNavigationService.to(SIMD2<Float>(6, 4)),
            IndoorNavigationService.to(SIMD2<Float>(4, 4))
        )
//        drawPolyLine(points:
//                     CLLocationCoordinate2D(latitude: 45.74722467016889, longitude: 21.23149894712361),
//                     CLLocationCoordinate2D(latitude: 45.74722467016889, longitude: 21.231286312177417),
//                     CLLocationCoordinate2D(latitude: 45.74702405732543, longitude: 21.231286312177417),
//                     CLLocationCoordinate2D(latitude: 45.74702405732543, longitude: 21.23149894712361),
//                     CLLocationCoordinate2D(latitude: 45.74722467016889, longitude: 21.23149894712361))
        
//        let from = GKGraphNode2D(point: SIMD2<Float>(45.74705846624135, 21.230672431267912))
//        let to = GKGraphNode2D(point: SIMD2<Float>(45.747272157228664, 21.231955369384778))
        let from = GKGraphNode2D(point: SIMD2<Float>(2, 5))
        let to = GKGraphNode2D(point: SIMD2<Float>(8, 5))
        let path = navService.computePath(from: from, to: to)
        print(path)
        if path.count <= 0 {
            return
        }
        drawPolyLine(color: .green, points: path.map(IndoorNavigationService.to(_:)))
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
            print("Couldn't find UVTData json.")
            return
        }
        
        let url = URL(fileURLWithPath: path)

            let geoJsonParser = GMUGeoJSONParser(url: url)
            geoJsonParser.parse()

            let renderer = GMUGeometryRenderer(map: mapView, geometries: geoJsonParser.features)
            renderer.render()
    }
    
    private func drawPolyLine(color: UIColor, points: CLLocationCoordinate2D...) {
        return drawPolyLine(color: color, points: points)
    }
    
    private func drawPolyLine(color: UIColor, points: [CLLocationCoordinate2D]) {
        let path = GMSMutablePath()
        for p in points {
            path.add(p)
        }

        let rectangle = GMSPolyline(path: path)
        rectangle.strokeColor = color
        rectangle.map = mapView
        rectangle.strokeWidth = 4
    }
    
    static func createGoogleMapsService() -> GoogleMapsService {
        GMSServices.provideAPIKey("AIzaSyBvpb75co2ehXH-qG420MrwPhhZbmqJRVM")
//        let map = GMSMapView(frame: CGRect.null, mapID: GMSMapID(identifier: "6f2428702d0bdd32"), camera: GMSCameraPosition())
        let map = GMSMapView()
        return GoogleMapsService(mapView: map);
    }
}
