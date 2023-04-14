//
//  MapModel.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 14.04.2023.
//

import Foundation
import GoogleMaps

class Point {
    public let coordinates: CLLocationCoordinate2D
    public let level: Int
    
    init(coordinates: CLLocationCoordinate2D, level: Int) {
        self.coordinates = coordinates
        self.level = level
    }
}

class Path {
    public let points: [Point]
    
    init(points: [Point]) {
        self.points = points
    }
}

class Room {
    public let index: String
    public let name: String
    public let coordinates: [CLLocationCoordinate2D]
    public let level: Int
    
    public var center: CLLocationCoordinate2D {
        get {
            var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            for coo in coordinates {
                center.latitude += coo.latitude
                center.longitude += coo.longitude
            }
            
            return CLLocationCoordinate2D(latitude: center.latitude / Double(coordinates.count), longitude: center.longitude / Double(coordinates.count))
        }
    }
    
    init(index: String, name: String, coordinates: [CLLocationCoordinate2D], level: Int) {
        self.index = index
        self.name = name
        self.coordinates = coordinates
        self.level = level
    }
}

class MapModel {
    public var currentPath: Path?
    public var selectedRoom: Room?
    public var rooms: [Room]
    
    init() {
        self.currentPath = nil
        self.selectedRoom = nil
        self.rooms = []
    }
}
