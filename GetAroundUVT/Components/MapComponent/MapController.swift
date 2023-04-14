//
//  MapController.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 14.04.2023.
//

import os
import Foundation
import GoogleMaps
import GoogleMapsUtils

class MapController: NSObject, GMSMapViewDelegate {
    private let mapRenderer: MapRenderer
    private let backendService: GetAroundUVTBackendService
    private var mapModel: MapModel
    
    public var renderer: MapRenderer {
        get {
            return mapRenderer
        }
    }
    
    public var mapView: GMSMapView {
        get {
            return mapRenderer.mapView
        }
    }
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "MapController"
    )
    
    init(mapRenderer: MapRenderer) {
        self.mapModel = MapModel()
        self.backendService = GetAroundUVTBackendService()
        self.mapRenderer = mapRenderer
        super.init()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    public func loadMetadata() async throws {
        try await getRooms()
    }
    
    private func getRooms() async throws {
        mapModel.rooms = try await backendService.getRooms()
        renderer.renderRooms(mapModel.rooms)
    }
    
    private func computePath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async throws -> Path {
//        start = CLLocationCoordinate2D(latitude: 45.74709967354057, longitude: 21.229815840527);
//        end = CLLocationCoordinate2D(latitude: 45.74672276497516, longitude: 21.23155186839855);
        let path = try await backendService.getPath(start: start, end: end)
        renderer.renderPath(path)
        return path
    }
    
    public func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("tapped: \(overlay)")
        
        if let polygon = overlay as? GMSPolygon {
            if let myLocation = mapView.myLocation {
                let room = renderer.getRoom(polygon)
                mapModel.selectedRoom = room
                renderer.highlightRoom(room)
                Task {
                    do {
                        let path = try await computePath(start: myLocation.coordinate, end: room.center)
                        mapModel.currentPath = path
                        renderer.renderPath(path)
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
    
    public func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        renderer.mapWasDragged()
    }
}
