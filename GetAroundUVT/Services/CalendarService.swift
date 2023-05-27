//
//  GoogleCalendarService.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 27.05.2023.
//

import Foundation
import EventKit

enum CalendarError: Error {
    case requestAccess
}

class CalendarService {
    private static var instance: CalendarService?
    
    public static func Instance() -> CalendarService {
        if (instance == nil) {
            instance = CalendarService()
        }
        return instance!
    }
    
    public func fetchEvents(from: Date, to: Date) async throws -> [Event] {
        let store = EKEventStore()
        let granted = try await store.requestAccess(to: .event)
        if !granted {
            throw CalendarError.requestAccess
        }
        
        // Create the predicate from the event store's instance method.
        let predicate = store.predicateForEvents(withStart: from, end: to, calendars: nil)

        // Fetch all events that match the predicate.
        let events: [EKEvent]? = store.events(matching: predicate)
        return events?.map({ ekEvent in
            return Event(id: ekEvent.eventIdentifier, eventTitle: ekEvent.title, eventDescription: ekEvent.notes, eventDate: ekEvent.startDate, eventLocation: ekEvent.location, isAllDay: ekEvent.isAllDay)
        }) ?? []
    }
}
