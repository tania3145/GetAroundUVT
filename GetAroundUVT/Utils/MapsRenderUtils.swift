//
//  MapsRenderUtils.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 10.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils

enum MapsRenderUtilsErrors: Error {
    case uvtAssetsFailedToLoad
}

extension GMSMapView {
    public static let DEFAULT_STROKE_WEIGHT: CGFloat = 4
    
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
    
    public func loadUVTAssets() throws -> GMUGeometryRenderer {
        guard let path = Bundle.main.path(forResource: "UVTData", ofType: "json") else {
            throw MapsRenderUtilsErrors.uvtAssetsFailedToLoad
        }
        
        let url = URL(fileURLWithPath: path)

        let geoJsonParser = GMUGeoJSONParser(url: url)
        geoJsonParser.parse()

        let renderer = GMUGeometryRenderer(map: self, geometries: geoJsonParser.features)
        renderer.render()
        renderer.mapOverlays().forEach() { o in
            o.isTappable = false
        }
        return renderer
    }
}
