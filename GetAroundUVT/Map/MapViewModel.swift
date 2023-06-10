//
//  MapViewModel.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 15.04.2023.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils

struct Point {
    public let coordinates: CLLocationCoordinate2D
    public let level: Int
}

struct Path {
    public let points: [Point]
}

struct Room : Hashable {
    public let index: String
    public let name: String
    public let coordinates: [CLLocationCoordinate2D]
    public let level: Int
    public var center: CLLocationCoordinate2D {
        get {
            var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            for coo in coordinates {
                center.latitude += coo.latitude
                center.longitude += coo.longitude
            }
            
            return CLLocationCoordinate2D(latitude: center.latitude / Double(coordinates.count), longitude: center.longitude / Double(coordinates.count))
        }
    }
    
    public func isToilet() -> Bool {
        return name.lowercased().contains("toilet")
    }
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.index == rhs.index
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index.hashValue)
    }
}

struct Building {
    public let rooms: [Room]
    public let floor: Room
}

enum MapViewModelError: Error {
    case floorExtractError(String)
}

class MapViewModel: NSObject, ObservableObject, GMSMapViewDelegate {
    @Published var mapView: GMSMapView = {
        GMSServices.provideAPIKey("AIzaSyBvpb75co2ehXH-qG420MrwPhhZbmqJRVM")
        // [DO NOT DELETE COMMENT BELOW] Enable custom styling
         let mapView = GMSMapView(frame: CGRect.null, mapID: GMSMapID(identifier: "6f2428702d0bdd32"), camera: GMSCameraPosition())
//        let mapView = GMSMapView()
        return mapView
    }()
    @Published var query: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = "Exception occurred"
    @Published var alertMessage: String = ""
    @Published var building: Building?
    
    public static let UVT_LOCATION = CLLocationCoordinate2D(latitude: 45.74717, longitude: 21.23105)
    private let DEFAULT_ZOOM_LEVEL: Float = 17.5
    
    private var mapRenderer: MapRenderer!
    private let backendService: NavigationService
    
    private func createBuildingFromRooms(rooms: [Room]) throws -> Building {
        var floor: Int? = nil
        for i in 0...rooms.count-1 {
            if rooms[i].name == "Parter" {
                floor = i
                break
            }
        }
        if floor == nil {
            throw MapViewModelError.floorExtractError("Couldn't extract floor named Parter.")
        }
        var roomsCopy = rooms.map({$0})
        roomsCopy.remove(at: floor!)
        return Building(rooms: roomsCopy, floor: rooms[floor!])
    }
    
    override init() {
        backendService = NavigationService.Instance()
        super.init()
        mapRenderer = MapRenderer(mapView: mapView)
        
        mapView.isMyLocationEnabled = true
        DispatchQueue.main.async { [weak self] in
            Task {
                do {
                    self?.moveCameraTo(MapViewModel.UVT_LOCATION)
//                    _ = try self?.mapRenderer.loadUVTAssets()
                    
                    if let rooms = try await self?.backendService.getRooms() {
                        self?.building = try self?.createBuildingFromRooms(rooms: rooms)
                    }
                    
                    if let building = self?.building {
                        self?.mapRenderer.renderBuilding(building)
                    }
                } catch {
                    self?.showAlert = true
                    self?.alertMessage = "\(error)"
                }
            }
        }
    }
    
    public func selectRoom(room: Room) {
//        query = room.name
        guard let myLocation = mapView.myLocation else { return }
        mapRenderer.clearMap()
        DispatchQueue.main.async { [weak self] in
            Task {
                do {
                    self?.mapRenderer.highlightRoom(room)
                    guard let path = try await self?.computePath(start: myLocation.coordinate, end: room.center) else { return }
                    self?.mapRenderer.renderPath(path)
                } catch {
                    self?.showAlert = true
                    self?.alertMessage = "\(error)"
                }
            }
        }
    }
    
    public func computePath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async throws -> Path {
//        start = CLLocationCoordinate2D(latitude: 45.74709967354057, longitude: 21.229815840527);
//        end = CLLocationCoordinate2D(latitude: 45.74672276497516, longitude: 21.23155186839855);
        let path = try await backendService.getPath(start: start, end: end)
        mapRenderer.renderPath(path)
        return path
    }
    
    public func goToFriend(friend: Person) {
        guard let myLocation = mapView.myLocation else { return }
        guard let end = friend.location else { return }
        DispatchQueue.main.async { [weak self] in
            Task {
                do {
                    guard let path = try await self?.computePath(start: myLocation.coordinate, end: end) else { return }
                    self?.mapRenderer.clearMap()
                    self?.mapRenderer.renderFriend(friend)
                    self?.mapRenderer.renderPath(path)
                } catch {
                    self?.showAlert = true
                    self?.alertMessage = "\(error)"
                }
            }
        }
    }
    
    public func moveCameraToMyLocation() {
        moveCameraTo(mapView.myLocation?.coordinate ?? MapViewModel.UVT_LOCATION)
    }
    
    public func moveCameraTo(_ location: CLLocationCoordinate2D, withAnimation: Bool = false) {
        let camera = GMSCameraPosition(
            latitude: location.latitude,
            longitude: location.longitude,
            zoom: DEFAULT_ZOOM_LEVEL)
        
        if withAnimation {
            let uvtCam = GMSCameraUpdate.setCamera(camera)
            mapView.animate(with: uvtCam)
        } else {
            mapView.camera = camera
        }
    }
    
    func updateUserLocation() async throws {
        let service = FirebaseService.Instance()
        guard let coo = await mapView.myLocation?.coordinate else {
            return
        }
        try await service.updateCurrentUserLocation(location: Location(lat: Double(coo.latitude), long: Double(coo.longitude)))
    }
    
    public func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        guard let room = mapRenderer.overlayToRoom(overlay) else { return }
        selectRoom(room: room)
    }

    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapRenderer.clearMap()
    }
}
