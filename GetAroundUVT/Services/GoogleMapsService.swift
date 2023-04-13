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

extension GMSPolygon {
    func center() -> CLLocationCoordinate2D {
        var center = vector_double2(0, 0)
        
        for i in 0...path!.count()-1 {
            center.x += path!.coordinate(at: i).latitude
            center.y += path!.coordinate(at: i).longitude
        }
        
        return CLLocationCoordinate2D(latitude: center.x / Double(path!.count()), longitude: center.y / Double(path!.count()))
    }
}

class GoogleMapsService : NSObject, GMSMapViewDelegate {
    private let UVT_LOCATION = CLLocationCoordinate2D(latitude: 45.74717, longitude: 21.23105)
    private let DEFAULT_ZOOM_LEVEL: Float = 17.5
    
    public let mapView: GMSMapView
    private let navService: NavigationService
    private var previousPath: GMSPolyline? = nil
    private var previousPolygon: GMSPolygon? = nil
    
    private init(mapView: GMSMapView) {
        self.mapView = mapView
        self.navService = NavigationService()
        super.init()
        
        setupMapView()
    }
    
    public func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("tapped: \(overlay)")
        
        if let polygon = overlay as? GMSPolygon {
            if let myLocation = mapView.myLocation {
                previousPath?.map = nil
                previousPolygon?.fillColor = .white.withAlphaComponent(0)
                previousPolygon = polygon
                polygon.fillColor = .purple.withAlphaComponent(0.3)
                Task {
                    do {
                        previousPath = try await computePath(start: myLocation.coordinate, end: polygon.center())
                    } catch {
                        print("Error encountered: \(error)")
                    }
                }
            }
        }
    }
    
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
    
    private func setupMapView() {
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        _ = try? mapView.loadUVTAssets()
        moveCameraToUVT()
        Task {
            do {
                try await setupRooms()
            } catch {
                print("Error encountered: \(error)")
            }
        }
    }
    
    private func setupRooms() async throws {
        let rooms = try await navService.getPoi()
        
        for (key, value) in rooms {
            let polygon = await mapView.renderPolygon(points: value.map() { p in
                return CLLocationCoordinate2D(latitude: p[0], longitude: p[1])
            }, fillColor: .white.withAlphaComponent(0), strokeWeight: 1)
            polygon.isTappable = true
            
            let marker = GMSMarker()
            marker.position = polygon.center()
            marker.isTappable = false
            marker.title = key
            marker.map = mapView
        }
    }
    
    public func getUserLocation() {
        
    }
    
    private func computePath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async throws -> GMSPolyline {
//        start = CLLocationCoordinate2D(latitude: 45.74709967354057, longitude: 21.229815840527);
//        end = CLLocationCoordinate2D(latitude: 45.74672276497516, longitude: 21.23155186839855);
        let path = try await navService.getPath(start: start, end: end)
        return await mapView.renderPolyLine(points: path.map({p in CLLocationCoordinate2D(latitude: p[0], longitude: p[1])}), strokeColor: .green)
    }
    
    public func moveCameraToUVT(withAnimation: Bool = false) {
        let camera = GMSCameraPosition(
            latitude: UVT_LOCATION.latitude,
            longitude: UVT_LOCATION.longitude,
            zoom: DEFAULT_ZOOM_LEVEL)
        
        if withAnimation {
            let uvtCam = GMSCameraUpdate.setCamera(camera)
            mapView.animate(with: uvtCam)
        } else {
            mapView.camera = camera
        }
    }
    
    static func createGoogleMapsService() -> GoogleMapsService {
        GMSServices.provideAPIKey("AIzaSyBvpb75co2ehXH-qG420MrwPhhZbmqJRVM")
        // [DO NOT DELETE COMMENT BELOW] Enable custom styling
//        let map = GMSMapView(frame: CGRect.null, mapID: GMSMapID(identifier: "6f2428702d0bdd32"), camera: GMSCameraPosition())
        let map = GMSMapView()
        return GoogleMapsService(mapView: map);
    }
}
