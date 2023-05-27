//
//  CalendarView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var eventModel: EventViewModel = EventViewModel()
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        CalendarContent(eventModel: eventModel)
            .onAppear {
                DispatchQueue.main.async {
                    Task {
                        await fetchCalendarEvents()
                    }
                }
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Exception occurred"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
    
    private func fetchCalendarEvents() async {
        do {
            let service = CalendarService.Instance()
            eventModel.storedEvents = try await service.fetchEvents(from: eventModel.currentWeek.first!, to: Calendar.current.date(byAdding: .day, value: 1, to: eventModel.currentWeek.last!)!)
            eventModel.filterTodayEvents()
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
