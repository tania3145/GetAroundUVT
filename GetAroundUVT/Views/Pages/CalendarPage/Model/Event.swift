//
//  Event.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 22.05.2023.
//

import SwiftUI
import SwiftSoup

struct Event: Identifiable {
    var id = UUID().uuidString
    var eventTitle: String
    var eventDescription: String?
    var eventDate: Date
    var eventLocation: String?
    var isAllDay: Bool = false
    
    func parseHTMLText(_ html: String) -> String? {
        do {
           let doc: Document = try SwiftSoup.parse(html)
           return try doc.text()
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getParsedEventDescription() -> String? {
        if eventDescription == nil {
            return nil
        }
        
        return parseHTMLText(eventDescription!)
    }
    
    func getParsedEventLocation() -> String? {
        if eventLocation == nil {
            return nil
        }
        
        return parseHTMLText(eventLocation!)
    }
}
