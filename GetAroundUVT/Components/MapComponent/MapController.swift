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
    private let backendService: GetAroundUVTBackendService
    private var mapModel: MapModel
    private var mapComponentView: MapComponentView!
    
    public var view: MapComponentView {
        get {
            return mapComponentView
        }
    }
    
    private var renderer: MapRenderer {
        get {
            return mapComponentView.mapRenderer
        }
    }
    
    private var mapView: GMSMapView {
        get {
            return mapComponentView.mapRenderer.mapView
        }
    }
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "MapController"
    )
    
    override init() {
        self.mapModel = MapModel()
        self.backendService = GetAroundUVTBackendService()
        super.init()
    }
    
    public func attachView(mapComponentView: MapComponentView) {
        self.mapComponentView = mapComponentView
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        Task {
            do {
                try await getRooms()
            } catch {
                logger.error("ERROR ENCOUNTERED: \(error)")
            }
        }
    }
    
    public func getRooms() async throws {
        mapModel.rooms = try await backendService.getRooms()
        renderer.renderRooms(mapModel.rooms)
    }
    
    public func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("tapped: \(overlay)")
        
        if let polygon = overlay as? GMSPolygon {
            if let myLocation = mapView.myLocation {
                let room = renderer.getRoom(polygon)
                renderer.highlightRoom(room)
                Task {
                    do {
                        let path = try await computePath(start: myLocation.coordinate, end: room.center)
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
    
    private func computePath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async throws -> Path {
//        start = CLLocationCoordinate2D(latitude: 45.74709967354057, longitude: 21.229815840527);
//        end = CLLocationCoordinate2D(latitude: 45.74672276497516, longitude: 21.23155186839855);
        let path = try await backendService.getPath(start: start, end: end)
        renderer.renderPath(path)
        return path
    }
}
