//
//  IndoorNavigationService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 09.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import GameplayKit

class IndoorNavigationService {
    init() {
    }
    
    public func computePath(from: GKGraphNode2D, to: GKGraphNode2D) -> [GKGraphNode2D] {
//        let obstacles = [
//            GKPolygonObstacle(points: [
//                SIMD2<Float>(45.74722467016889, 21.23149894712361),
//                SIMD2<Float>(45.74722467016889, 21.231286312177417),
//                SIMD2<Float>(45.74702405732543, 21.231286312177417),
//                SIMD2<Float>(45.74702405732543, 21.23149894712361),
//            ])
//        ]
        let obstacles = [
            GKPolygonObstacle(points: [
                SIMD2<Float>(4, 4),
                SIMD2<Float>(4, 6),
                SIMD2<Float>(6, 6),
                SIMD2<Float>(6, 4)
            ]),
            GKPolygonObstacle(points: [
                SIMD2<Float>(0, 0),
                SIMD2<Float>(0, 3.5),
                SIMD2<Float>(10, 3.5),
                SIMD2<Float>(10, 0)
            ])
        ]
        
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 2)
        graph.connectUsingObstacles(node: from)
        graph.connectUsingObstacles(node: to)
        return graph.findPath(from: from, to: to).map({ e in e as! GKGraphNode2D})
    }
    
    // Convert to extension function
    public static func to(_ from: CLLocationCoordinate2D) -> SIMD2<Float> {
        return SIMD2<Float>(Float(from.longitude), Float(from.latitude))
    }
    
    public static func to(_ from: SIMD2<Float>) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(from.y), longitude: Double(from.x))
    }
    
    public static func to(_ from: CLLocationCoordinate2D) -> GKGraphNode2D {
        return GKGraphNode2D(point: to(from))
    }
    
    public static func to(_ from: GKGraphNode2D) -> CLLocationCoordinate2D {
        return to(from.position)
    }
}
