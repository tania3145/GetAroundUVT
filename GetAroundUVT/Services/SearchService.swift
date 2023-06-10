//
//  SearchService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 10.06.2023.
//

import SwiftUI

class SearchService: ObservableObject {
    @Published var building: Building
    
    init(building: Building) {
        self.building = building
    }
}


//    @Published var searchedRoom : [Rooms] = []
//
//    // Room query
//    @Published var query = ""
//
//    // Current Result Page
//    @Published var page = 1
//
//    func find() {
//
//        // removing spaces
//        let searchQuery = query.replacingOccurrences(of: " ", with: "%20")
//
//        let filePath = "/Users/tania/Downloads/convertcsv.json?q=\(query)&page=\(page)&per_page=10"
//
//        let url = URL(fileURLWithPath: filePath)
//
//        // can give different length
////        let url = "https://raw.githubusercontent.com/tania3145/NavigationServer/main/Data/RoomsMetadata.csv?token=\(searchQuery)&page=\(page)&per_page=10"
//
//        let session = URLSession(configuration: .default)
//
////        session.dataTask(with: URL(string: url)!) { (data, _, err) in
//        session.dataTask(with: url) { (data, _, error) in
//            guard let jsonData = data else {return}
//
//            do {
//                let rooms = try JSONDecoder().decode(Results.self, from: jsonData)
//
//                // appending to search Rooms
//                DispatchQueue.main.async {
//
//                    // removing data if its new request
//                    if self.page == 1 {
//                        self.searchedRoom.removeAll()
//                    }
//
//                    // checking if any already loaded is again loaded
//
//                    // ignores already loaded
//                    self.searchedRoom = Array(Set(self.searchedRoom).union(Set(rooms.items)))
//                }
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//        .resume()
//    }
//}
//
//struct Rooms: Decodable, Hashable {
//    var name: String
//    var Coo1: String
//    var Coo2: String
//    var Coo3: String
//    var Coo4: String
//}
//
//struct Results: Decodable {
//    var items: [Rooms]
//}
