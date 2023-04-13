//
//  NavigationService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 11.04.2023.
//

import Foundation
import GameplayKit
import GoogleMaps
import GoogleMapsUtils

extension CLLocationCoordinate2D {
    func toQueryItem(_ name: String, level: Int = 0) -> URLQueryItem {
        return URLQueryItem(name: name, value: "\(latitude),\(longitude),\(level)")
    }
}

class NavigationService {
    
    private static let NAVIGATION_API_BASE_URL = URL(string: "https://d7d9-2a02-2f01-410f-2f00-2da2-a95-4950-2d5.ngrok-free.app")!;
    private static let NAVIGATION_API_PATH_METHOD = "/path";
    private static let NAVIGATION_API_POI_METHOD = "/poi";
    
    private func getJson<T>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T where T: Decodable {
        let baseUrl = NavigationService.NAVIGATION_API_BASE_URL
            .appendingPathComponent(path)
            .appending(queryItems: queryItems)
        let urlRequest = URLRequest(url: baseUrl)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func getPoi() async throws -> Dictionary<String, [[Double]]> {
        return try await getJson(NavigationService.NAVIGATION_API_POI_METHOD)
    }
    
    func getPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async throws -> [[Double]] {
        return try await getJson(NavigationService.NAVIGATION_API_PATH_METHOD, queryItems: [start.toQueryItem("start"), end.toQueryItem("end")])
    }
}
