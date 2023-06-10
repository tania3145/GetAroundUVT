//
//  SearchBarWidget.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI


struct SearchBarWidget: View {
    @State public var queriedRoom: Room?
    @State var suggestedRooms: [Room] = []
    @StateObject var mapViewModel : MapViewModel
    var focusedField: FocusState<String?>.Binding
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                TextField("Search", text: $mapViewModel.query)
                    .autocapitalization(.none)
                    .focused(focusedField, equals: "searchField")
                    .onChange(of: mapViewModel.query) { _ in
                        queriedRoom = nil
                        findRoom()
                        if queriedRoom?.name == mapViewModel.query {
                            suggestedRooms = []
                        }
                    }
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
            
            if !suggestedRooms.isEmpty {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(alignment: .leading,  spacing: 15) {
                        // Safe Wrap
                        ForEach(suggestedRooms, id: \.self) {room in
                            VStack(alignment: .leading, spacing: 6) {
                                Button(room.name) {
                                    mapViewModel.query = room.name
                                    mapViewModel.selectRoom(room: room)
                                }
                                Divider()
                            }
                            .padding(.horizontal)
//                            .onAppear {
//
//                                // stopping search until 3rd page
//                                // can be changed
//                                if room.Coo1 == searchService.searchedRoom.last?.Coo1 && searchService.page <= 3 {
//                                    searchService.page += 1
//                                    searchService.find()
//                                }
//                            }
                        }
                    }
                    .padding(.top)
                }
                .frame(height: calculateHeight(maxHeight: 240))
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
    
    func calculateHeight(maxHeight: CGFloat) -> CGFloat {
        guard !suggestedRooms.isEmpty else {
            return 0
        }
        
        let elementCount = CGFloat(suggestedRooms.count)
        let itemHeight: CGFloat = 40 // Specify your desired height for each item
        let spacing: CGFloat = 10 // Specify your desired spacing between items
        
        // Calculate the total height based on the number of elements and their respective heights
        let totalHeight = (elementCount * itemHeight) + ((elementCount - 1) * spacing)
        
        // You can add additional conditions or logic here if needed
        // For example, you may want to set a minimum or maximum height
        
        return CGFloat.minimum(totalHeight, maxHeight)
    }
    
    func findRoom() {
        guard let building = mapViewModel.building else {
            return
        }
        
        suggestedRooms = building.rooms.filter { room in
            room.name.lowercased().replacingOccurrences(of: " ", with: "", options: .literal, range: nil).contains(mapViewModel.query.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).lowercased())
        }
        
        if suggestedRooms.isEmpty {
            queriedRoom = nil
        }
        
        queriedRoom = suggestedRooms.first { room in
            mapViewModel.query == room.name
        }
    }
    
    
    
//    @Binding var text: String
//
//    var body: some View {
//        HStack {
//            Spacer()
//            Spacer()
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.gray)
//            TextField("", text: $text)
//                .foregroundColor(.black)
//                .padding(8)
//                .background(Color.white)
//                .cornerRadius(8)
//                .padding(.trailing, 8)
//                .overlay(
//                    Text("Search")
//                        .font(.system(size: 20, weight: .regular, design: .default))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .foregroundColor(.gray)
//                        .padding(.leading, 4)
//                        .padding(.trailing, 2)
//                        .opacity(100)
//                )
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 16)
//        .background(Color.white)
//        .cornerRadius(20)
//        .padding(.horizontal)
//    }
}

//struct SearchBarWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarWidget(text: .constant(""))
//    }
//}
