//
//  MapComponentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 14.04.2023.
//

import os
import Foundation
import SwiftUI
import GoogleMaps
import GoogleMapsUtils

enum MapsRenderUtilsErrors: Error {
    case uvtAssetsFailedToLoad
}

extension GMSMapView {
    public static let DEFAULT_STROKE_WEIGHT: CGFloat = 4
    
    public func renderMarker(title: String, position: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = title
        marker.position = position
        marker.map = self
        return marker
    }
    
    public func renderLine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, strokeColor: UIColor) -> GMSPolyline {
        return renderPolyLine(points: [from, to], strokeColor: strokeColor)
    }
    
    public func renderPolyLine(points: CLLocationCoordinate2D..., strokeColor: UIColor) -> GMSPolyline {
        return renderPolyLine(points: points, strokeColor: strokeColor)
    }
    
    public func renderPolyLine(points: [CLLocationCoordinate2D], strokeColor: UIColor) -> GMSPolyline {
        let path = GMSMutablePath()
        for p in points {
            path.add(p)
        }

        let rectangle = GMSPolyline(path: path)
        rectangle.strokeColor = strokeColor
        rectangle.strokeWidth = GMSMapView.DEFAULT_STROKE_WEIGHT
        rectangle.map = self
        return rectangle
    }
    
    public func renderPolygon(points: CLLocationCoordinate2D..., fillColor: UIColor, strokeColor: UIColor = .black, strokeWeight: CGFloat = GMSMapView.DEFAULT_STROKE_WEIGHT) -> GMSPolygon {
        return renderPolygon(points: points, fillColor: fillColor, strokeColor: strokeColor, strokeWeight: strokeWeight)
    }
    
    public func renderPolygon(points: [CLLocationCoordinate2D], fillColor: UIColor, strokeColor: UIColor = .black, strokeWeight: CGFloat = GMSMapView.DEFAULT_STROKE_WEIGHT) -> GMSPolygon {
        let rect = GMSMutablePath()
        for p in points {
            rect.add(p)
        }

        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = fillColor;
        polygon.strokeColor = .black
        polygon.strokeWidth = strokeWeight
        polygon.map = self
        return polygon
    }
    
    public func renderCircle(_ center: CLLocationCoordinate2D, radius: Double, fillColor: UIColor, strokeColor: UIColor = .black) -> GMSCircle {
        let circle = GMSCircle(position: center, radius: radius)
        circle.fillColor = fillColor
        circle.strokeColor = strokeColor
        circle.strokeWidth = GMSMapView.DEFAULT_STROKE_WEIGHT
        circle.map = self
        return circle
    }
}

class RoomToPolygonCollection {
    private var roomIndexToPolygon: Dictionary<String, GMSPolygon> = Dictionary<String, GMSPolygon>()
    private var polygonToRoomIndex: Dictionary<GMSPolygon, Room> = Dictionary<GMSPolygon, Room>()
    
    public func getRoom(_ polygon: GMSPolygon) -> Room {
        return polygonToRoomIndex[polygon]!
    }
    
    public func getPolygon(_ room: Room) -> GMSPolygon {
        return roomIndexToPolygon[room.index]!
    }
    
    public func addRoomPolygon(_ room: Room, _ polygon: GMSPolygon) {
        roomIndexToPolygon[room.index] = polygon
        polygonToRoomIndex[polygon] = room
    }
}

class RenderedState {
    public var currentDrawnPath: GMSPolyline?
    public var currentHighlightedRoom: GMSPolygon?
    public var roomPolygons: RoomToPolygonCollection = RoomToPolygonCollection()
}

class MapRenderer {
    public static let UVT_LOCATION = CLLocationCoordinate2D(latitude: 45.74717, longitude: 21.23105)
    private let DEFAULT_ZOOM_LEVEL: Float = 17.5
    
    public let mapView: GMSMapView
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "MapComponentView"
    )
    private var renderedState: RenderedState
    
    convenience init() {
        // [DO NOT DELETE COMMENT BELOW] Enable custom styling
        // let mapView = GMSMapView(frame: CGRect.null, mapID: GMSMapID(identifier: "6f2428702d0bdd32"), camera: GMSCameraPosition())
        let mapView = GMSMapView()
        self.init(mapView: mapView)
    }
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
        self.renderedState = RenderedState()
        
        do {
            _ = try loadUVTAssets()
        } catch {
            logger.error("ERROR ENCOUNTERED: \(error)")
        }
        moveCameraTo(MapRenderer.UVT_LOCATION)
    }
    
    public func getRoom(_ polygon: GMSPolygon) -> Room {
        return renderedState.roomPolygons.getRoom(polygon)
    }
    
    public func renderRooms(_ rooms: [Room]) {
        for room in rooms {
            let polygon = mapView.renderPolygon(points: room.coordinates, fillColor: .white.withAlphaComponent(0), strokeWeight: 1)
            polygon.isTappable = true
            let marker = mapView.renderMarker(title: room.name, position: room.center)
            marker.isTappable = true
            renderedState.roomPolygons.addRoomPolygon(room, polygon)
        }
    }
    
    public func renderPath(_ path: Path) {
        renderedState.currentDrawnPath?.map = nil
        renderedState.currentDrawnPath = mapView.renderPolyLine(points: path.points.map { point in
            return point.coordinates
        }, strokeColor: .green)
    }
    
    public func highlightRoom(_ room: Room) {
        renderedState.currentHighlightedRoom?.fillColor = .white.withAlphaComponent(0)
        renderedState.currentHighlightedRoom = renderedState.roomPolygons.getPolygon(room)
        renderedState.currentHighlightedRoom?.fillColor = .purple.withAlphaComponent(0.3)
    }
    
    public func moveCameraTo(_ location: CLLocationCoordinate2D, withAnimation: Bool = false) {
        let camera = GMSCameraPosition(
            latitude: location.latitude,
            longitude: location.longitude,
            zoom: DEFAULT_ZOOM_LEVEL)
        
        if withAnimation {
            let uvtCam = GMSCameraUpdate.setCamera(camera)
            mapView.animate(with: uvtCam)
        } else {
            mapView.camera = camera
        }
    }
    
    public func loadUVTAssets() throws -> GMUGeometryRenderer {
        guard let path = Bundle.main.path(forResource: "UVTData", ofType: "json") else {
            throw MapsRenderUtilsErrors.uvtAssetsFailedToLoad
        }
        
        let url = URL(fileURLWithPath: path)

        let geoJsonParser = GMUGeoJSONParser(url: url)
        geoJsonParser.parse()

        let renderer = GMUGeometryRenderer(map: mapView, geometries: geoJsonParser.features)
        renderer.render()
        renderer.mapOverlays().forEach() { o in
            o.isTappable = false
        }
        return renderer
    }
}

struct MapComponentView: UIViewRepresentable {
    @State public var mapRenderer: MapRenderer = MapRenderer()
    @Binding public var mapController: MapController
    
    func makeUIView(context: Context) -> UIView {
        return mapRenderer.mapView;
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
