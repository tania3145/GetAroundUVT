//
//  GMSMapViewExtensions.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 15.04.2023.
//

import Foundation
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

class MapRenderer {
    public var currentDrawnPath: GMSPolyline?
    public var currentHighlightedRoom: GMSPolygon?
    public var roomPolygons: RoomToPolygonCollection = RoomToPolygonCollection()
    
    private var mapView: GMSMapView
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    public func renderBuilding(_ building: Building) {
        for room in building.rooms {
            renderRoom(room)
        }
    }
    
    public func renderRoom(_ room: Room) {
        let polygon = mapView.renderPolygon(points: room.coordinates, fillColor: .white.withAlphaComponent(0), strokeWeight: 1)
        polygon.isTappable = true
        let marker = mapView.renderMarker(title: room.name, position: room.center)
        marker.isTappable = true
        roomPolygons.addRoomPolygon(room, polygon)
    }
    
    public func renderPath(_ path: Path) {
        currentDrawnPath?.map = nil
        currentDrawnPath = mapView.renderPolyLine(points: path.points.map { point in
            return point.coordinates
        }, strokeColor: .green)
    }
    
    public func highlightRoom(_ room: Room) {
        currentHighlightedRoom?.fillColor = .white.withAlphaComponent(0)
        currentHighlightedRoom = roomPolygons.getPolygon(room)
        currentHighlightedRoom?.fillColor = .purple.withAlphaComponent(0.3)
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
    
    public func overlayToRoom(_ overlay: GMSOverlay) -> Room? {
        if let polygon = overlay as? GMSPolygon {
            return roomPolygons.getRoom(polygon)
        }
        return nil
    }
}
