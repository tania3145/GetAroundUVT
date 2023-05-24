//
//  CalendarContent.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 22.05.2023.
//

import SwiftUI

struct CalendarContent: View {
    @StateObject var eventModel: EventViewModel = EventViewModel()
    @Namespace var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10){
                            ForEach(eventModel.currentWeek, id: \.self){day in
                                
                                VStack(spacing: 10){
                                    
                                    Text(eventModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    // EEE displays day as MON, TUE, ...etc
                                    Text(eventModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(eventModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(eventModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(eventModel.isToday(date: day) ? .white : .black)
                                // MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack{
                                        // MARK: Matched Geometry Effect
                                        if eventModel.isToday(date: day){
                                            Capsule()
                                                .fill(Color(red: 0.859, green: 0.678, blue: 0.273)) // Yellow UVT Color
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation{
                                        eventModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    EventsView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
//        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
    }
    
    // MARK: Events View
    func EventsView()->some View{
        
        LazyVStack(spacing: 18) {
            if let events = eventModel.filteredEvents {
                
                if events.isEmpty{
                    Text("No events scheduled for today.")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }
                else{
                    ForEach(events){event in
                        EventsCardView(events: event)
                    }
                }
            }
            else{
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
                }
            }
        .padding()
        .padding(.top)
        // MARK: Updating Events
        .onChange(of: eventModel.currentDay){ newValue in
            eventModel.filterTodayEvents()
        }
    }
    
    // MARK: Events Card View
    func EventsCardView(events: Event)->some View {
        HStack(alignment: .top, spacing: 30){
            VStack(spacing: 10){
                Circle()
                    .fill(Color(red: 0.859, green: 0.678, blue: 0.273))

                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .strokeBorder(Color(red: 0.859, green: 0.678, blue: 0.273), lineWidth: 1)
                            .padding(-3)
                        )
                    Rectangle()
                        .fill(Color(red: 0.859, green: 0.678, blue: 0.273))
                        .frame(width: 3)
            }
            
            VStack{
                HStack(alignment: .top, spacing: 10){
                    VStack(alignment: .leading, spacing: 12){
                        Text(events.eventTitle)
                            .font(.title2.bold())
                        Text(events.eventDescription)
                            .font(.title3.bold())
                        //                            .font(.callout)
                        //                            .foregroundColor(.secondary)
                        
                    }
                    .hLeading()
                    
                    Text(events.eventDate.formatted(date: .omitted, time: .shortened))
                }
                    
                // MARK: Location
                HStack(spacing: 0){
                    HStack(){
                        Text("Location: ")
                        Text(events.eventLocation)
                            .font(.title2.bold())
                    }
                    .hLeading()
                    
                    // MARK: Get Directions Button
                    Button(action: {
                                        
                    }) {
                        Text("Get Directions")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 0.859, green: 0.678, blue: 0.273))
                            .cornerRadius(10)
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                }
            }
            .foregroundColor(.white)
            .padding()
            .hLeading()
            .background(Color(red: 0.115, green: 0.287, blue: 0.448))
            .cornerRadius(25)
            .shadow(color: Color(red: 0.266, green: 0.436, blue: 0.699).opacity(0.5), radius: 2, x: 10, y: 10)
        }
        .hLeading()
    }
    
    // MARK: Header
    func HeaderView()->some View {
        
        HStack(spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
//                    .foregroundColor(.white)
                    .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)

        .background(Color.white)
//        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
    }
}



struct CalendarContent_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContent()
    }
}

// MARK: UI Design Helper functions
extension View{
    
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        return safeArea
    }
}

