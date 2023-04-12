//
//  NavigationService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 11.04.2023.
//

import Foundation
import GameplayKit

class NavigationService {
    
    private static let NAVIGATION_API_URL = URL(string: "https://6c30-2a02-2f01-410f-2f00-1447-906f-b0db-2dbd.ngrok-free.app")!;
    
//    func connect() async {
//        let task = URLSession.shared.dataTask(with: URLRequest(url: NavigationService.NAVIGATION_API_URL)) {(data, response, error) in
//            guard let data = data else { return }
//            let decoder = JSONDecoder()
//            let path = try? decoder.decode([[Float]].self, from: data)
//            return path
//        }
//        let result = try await task
//    }
    
    func getPath() async throws -> [[Double]] {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: NavigationService.NAVIGATION_API_URL))
        let decoder = JSONDecoder()
        return try decoder.decode([[Double]].self, from: data)
    }
}
