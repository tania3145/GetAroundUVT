//
//  EventsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct PostsView: View {
    @Binding var tabSelection: Int
    @StateObject var mapViewModel: MapViewModel
    
    var body: some View {
        FeedView(tabSelection: $tabSelection, mapViewModel: mapViewModel)
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(tabSelection: .constant(4), mapViewModel: MapViewModel())
    }
}
