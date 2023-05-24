//
//  Event.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 22.05.2023.
//

import SwiftUI

struct Event: Identifiable{
    var id = UUID().uuidString
    var eventTitle: String
    var eventDescription: String
    var eventDate: Date
    var eventLocation: String
}
