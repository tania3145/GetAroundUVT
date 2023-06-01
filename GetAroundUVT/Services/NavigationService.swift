//
//  NavigationService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 11.04.2023.
//

import Foundation
import GoogleMaps

extension CLLocationCoordinate2D {
    func toQueryItem(_ name: String, level: Int = 0) -> URLQueryItem {
        return URLQueryItem(name: name, value: "\(latitude),\(longitude),\(level)")
    }
}

struct RoomJsonData: Codable {
    public let index: String
    public let name: String
    public let coordinates: [[Double]]
}

class NavigationService {
    private static let NAVIGATION_API_BASE_URL = URL(string: "https://8bb6-2a02-2f01-4100-1b00-1071-4cc0-a91c-46ce.ngrok-free.app")!;
    private static let NAVIGATION_API_PATH_METHOD = "/path";
    private static let NAVIGATION_API_POI_METHOD = "/poi";
    
    private static var instance: NavigationService?
    
    public static func Instance() -> NavigationService {
        if (instance == nil) {
            instance = NavigationService()
        }
        return instance!
    }
    
    private init() {
    }
    
    private func getJson<T>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T where T: Decodable {
        let baseUrl = NavigationService.NAVIGATION_API_BASE_URL
            .appendingPathComponent(path)
            .appending(queryItems: queryItems)
        let urlRequest = URLRequest(url: baseUrl)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func getRooms() async throws -> [Room] {
        var rooms: [Room] = []
        let data: Array<RoomJsonData> = try await getJson(NavigationService.NAVIGATION_API_POI_METHOD)
        
        for row in data {
            let convertedPoints = row.coordinates.map { el in
                return (CLLocationCoordinate2D(latitude: el[0], longitude: el[1]), el[2])
            }
            rooms.append(Room(index: row.index, name: row.name, coordinates: convertedPoints.map { val in
                return val.0
            }, level: Int(convertedPoints.reduce(0) { (prevValue, el) in
                return prevValue + el.1
            } / Double(convertedPoints.count))))
        }
        return rooms
    }
    
    func getPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async throws -> Path {
        let data: [[Double]] = try await getJson(NavigationService.NAVIGATION_API_PATH_METHOD, queryItems: [start.toQueryItem("start"), end.toQueryItem("end")])
        return Path(points: data.map { point in
            return Point(coordinates: CLLocationCoordinate2D(latitude: point[0], longitude: point[1]), level: Int(point[2]))
        })
    }
}
