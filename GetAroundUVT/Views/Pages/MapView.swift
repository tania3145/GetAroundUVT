//
//  MapView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 14.04.2023.
//

import Foundation
import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct MapViewWrapper: UIViewRepresentable {
    let mapViewModel: MapViewModel
    
    func makeUIView(context: Context) -> UIView {
        mapViewModel.mapView.delegate = context.coordinator
        return mapViewModel.mapView;
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> MapViewModel {
        return mapViewModel
    }
}

struct MapView: View {
    @StateObject var mapViewModel: MapViewModel
    @FocusState private var focusedField: String?
    
    var body: some View {
        ZStack {
            MapViewWrapper(mapViewModel: mapViewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                
                SearchBarWidget(mapViewModel: mapViewModel, focusedField: $focusedField)
                    .padding(.top, 60)
                    .shadow(color: Color.gray, radius: 10, x: 5, y: 5)
                // Old Search bar
//                SearchBarWidget(text: $searchedText)
//                    .padding(.top, 60)
//                    .shadow(color: Color.gray, radius: 10, x: 5, y: 5)
                
                Spacer()
            }
//            .onChange(of: searchData.query) { (newData) in
////                print(newData)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                    if newData == searchData.query {
//                        print("search \(newData)")
//
//                        if searchData.query != "" {
//                            // searching Room
//                            searchData.page = 1
//                            searchData.find()
//                        }
//                        else {
//                            // removing all searched Data
//                            searchData.searchedRoom.removeAll()
//                        }
//                    }
//                }
//            }
            
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        mapViewModel.moveCameraToMyLocation()
                    }, label: {
                        Image(systemName: "location.fill")
                            .imageScale(.large)
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.white)
                    })
                    .background(Color.blue)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                }
            }.edgesIgnoringSafeArea(.top)
        }.alert(isPresented: $mapViewModel.showAlert) {
            Alert(
                title: Text(mapViewModel.alertTitle),
                message: Text(mapViewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        return MapView(mapViewModel: MapViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}
