//
//  MapsRenderUtils.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 10.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import GameplayKit

extension GMSMapView {

    private static let strokeWidth: CGFloat = 4
    
    public func render(_ node: GKGraphNode2D, radius: Float) {
        renderCircle(node.to(), radius: Double(radius) * 111000, fillColor: .cyan)
    }
    
    public func render(_ polygon: GKPolygonObstacle) {
        if polygon.vertexCount <= 0 {
            return
        }
        
        var points: [CLLocationCoordinate2D] = []
        for i in 0...polygon.vertexCount - 1 {
            points.append(polygon.vertex(at: i).to())
        }
        renderPolygon(points: points, fillColor: .red)
    }
    
    public func render(_ graph: GKMeshGraph<GKGraphNode2D>) {
        graph.obstacles.forEach() { o in
            render(o)
        }
        graph.nodes?.forEach() { n in
            if let n2d = n as? GKGraphNode2D {
                render(n2d, radius: graph.bufferRadius)
            } else {
                print("Cannot render GKGraphNode.")
            }
        }
        
        for i in 0...graph.triangleCount - 1 {
            let ps = graph.triangle(at: i).points
            renderPolyLine(points: [
                ps.0.to().to(),
                ps.1.to().to(),
                ps.2.to().to(),
                ps.0.to().to()
            ], strokeColor: .green)
        }
    }
    
    public func renderLine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, strokeColor: UIColor) {
        renderPolyLine(points: [from, to], strokeColor: strokeColor)
    }
    
    public func renderPolyLine(points: CLLocationCoordinate2D..., strokeColor: UIColor) {
        return renderPolyLine(points: points, strokeColor: strokeColor)
    }
    
    public func renderPolyLine(points: [CLLocationCoordinate2D], strokeColor: UIColor) {
        let path = GMSMutablePath()
        for p in points {
            path.add(p)
        }

        let rectangle = GMSPolyline(path: path)
        rectangle.strokeColor = strokeColor
        rectangle.strokeWidth = GMSMapView.strokeWidth
        rectangle.map = self
    }
    
    public func renderPolygon(points: CLLocationCoordinate2D..., fillColor: UIColor, strokeColor: UIColor = .black) {
        renderPolygon(points: points, fillColor: fillColor, strokeColor: strokeColor)
    }
    
    public func renderPolygon(points: [CLLocationCoordinate2D], fillColor: UIColor, strokeColor: UIColor = .black) {
        let rect = GMSMutablePath()
        for p in points {
            rect.add(p)
        }

        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = fillColor;
        polygon.strokeColor = .black
        polygon.strokeWidth = GMSMapView.strokeWidth
        polygon.map = self
    }
    
    public func renderCircle(_ center: CLLocationCoordinate2D, radius: Double, fillColor: UIColor, strokeColor: UIColor = .black) {
        let circle = GMSCircle(position: center, radius: radius)
        circle.fillColor = fillColor
        circle.strokeColor = strokeColor
        circle.strokeWidth = GMSMapView.strokeWidth
        circle.map = self
    }
}
