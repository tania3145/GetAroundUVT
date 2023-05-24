//
//  EventsView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct PostsView: View {
    var body: some View {
        FeedView(feed: [.demo1, .demo2, .demo3, .demo4])
//        FeedView()
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}