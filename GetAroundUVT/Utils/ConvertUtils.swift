//
//  ConvertUtils.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 10.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import GameplayKit

extension CLLocationCoordinate2D {
    func to() -> GKGraphNode2D {
        return GKGraphNode2D(point: vector_float2(Float(latitude), Float(longitude)))
    }
}

extension GKGraphNode2D {
    func to() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(position.x), longitude: Double(position.y))
    }
}

extension vector_float2 {
    func to() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(x), longitude: Double(y))
    }
}

extension vector_float3 {
    func to() -> vector_float2 {
        return vector_float2(x, y)
    }
}
