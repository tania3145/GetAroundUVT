//
//  FriendsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct FriendsView: View {
    @Binding var tabSelection: Int
    @StateObject var mapViewModel: MapViewModel
    
    var body: some View {
        FriendsContentView(tabSelection: $tabSelection, mapViewModel: mapViewModel, person: [.person1, .person2, .person3, .person4, .person5, .person6, .person7, .person8])
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(tabSelection: .constant(1), mapViewModel: MapViewModel())
    }
}

