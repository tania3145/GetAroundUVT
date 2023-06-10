//
//  EventViewModel.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 22.05.2023.
//

import SwiftUI

class EventViewModel: ObservableObject {

    // Sample Events
    @Published var storedEvents: [Event] = [
        
//        // 21 May
//        Event(eventTitle: "Metode Numerice", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684668052), eventLocation: "003"),
//        Event(eventTitle: "Securitate si Criptografie", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684661452), eventLocation: "A02"),
//        Event(eventTitle: "Prelucrarea Imaginilor", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684692052), eventLocation: "105"),
//        Event(eventTitle: "Metode Numerice", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684680052), eventLocation: "AM"),
//        
//        // 22 May
//        Event(eventTitle: "Grafica si Interfete Utilizator", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684778452), eventLocation: "AM"),
//        Event(eventTitle: "Securitate si Criptografie", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684772452), eventLocation: "103"),
//        Event(eventTitle: "Metode Numerice", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684784452), eventLocation: "003"),
//        Event(eventTitle: "Prelucrarea Imaginilor", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684748452), eventLocation: "105"),
//        Event(eventTitle: "Grafica si Interfete Utilizator", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684760452), eventLocation: "AM"),
//        Event(eventTitle: "Metode Numerice", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684789852), eventLocation: "003"),
//        
//        // 23 May
//        Event(eventTitle: "Securitate si Criptografie", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684858852), eventLocation: "A02"),
//        Event(eventTitle: "Prelucrarea Imaginilor", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684870852), eventLocation: "105"),
//        Event(eventTitle: "Metode Numerice", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684846852), eventLocation: "AM"),
//        Event(eventTitle: "Grafica si Interfete Utilizator", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684834852), eventLocation: "AM"),
//        Event(eventTitle: "Securitate si Criptografie", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684876252), eventLocation: "103"),
//        Event(eventTitle: "Metode Numerice", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684858852), eventLocation: "003"),
//        Event(eventTitle: "Prelucrarea Imaginilor", eventDescription: "Lab", eventDate: .init(timeIntervalSince1970: 1684840852), eventLocation: "105"),
//        Event(eventTitle: "Grafica si Interfete Utilizator", eventDescription: "Lecture", eventDate: .init(timeIntervalSince1970: 1684828852), eventLocation: "AM"),
//

    ]
    
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Actual Current Day
    public let actualToday: Date = Date()
    
    // MARK: Filtering Today Events
    @Published var filteredEvents: [Event]?
    
    // MARK: Initializing
    init(){
        fetchCurrentWeek()
        filterTodayEvents()
    }
    
    // MARK: Filter Today Events
    func filterTodayEvents(){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedEvents.filter{
                return calendar.isDate($0.eventDate, inSameDayAs: self.currentDay)
            }
                .sorted { event1, event2 in
                    return event1.eventDate < event2.eventDate
                }
            
            DispatchQueue.main.async {
                withAnimation{
                    self.filteredEvents = filtered
                }
            }
        }
    }
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String)->String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current Date is Today
    func isToday(date: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func isSameDayAsActualToday() -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: actualToday)
    }
    
    // MARK: Check if the current hour is event hour
    func isCurrentHour(date: Date)->Bool{
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
