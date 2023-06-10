//
//  FriendsContentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 08.06.2023.
//

import SwiftUI

struct FriendsContentView: View {
    @Binding var tabSelection: Int
    @StateObject var mapViewModel: MapViewModel
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Exception occurred"
    @State var alertMessage: String = ""
    @State var persons: [Person] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    VStack{
                        ScrollView{
                            LazyVStack{
                                ForEach(persons) { item in
                                    FriendsRowView(tabSelection: $tabSelection, mapViewModel: mapViewModel, personItem: item)
                                        .padding()
                                    Divider()
                                }
                            }
                        }
                    }
                }
                header: {
                   HeaderView()
               }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear() {
            let service = FirebaseService.Instance()
            DispatchQueue.main.async {
                Task {
                    do {
                        let friends = try await service.getAllUsers()
                        persons = friends.map { user in
                            convertToPerson(user: user)
                        }
                    } catch {
                        showAlert = true
                        alertMessage = "\(error)"
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
            
            //        .edgesIgnoringSafeArea(.top)
            //        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
        }
        
//        VStack{
//            HStack(spacing: 10) {
//                
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("People")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
//                }
//                .hLeading()
//            }
//            .padding()
//            .padding(.top, getSafeArea().top)
//
//            .background(Color.white)
//            
//            ScrollView{
//                LazyVStack{
//                    ForEach(person) { item in
//                        FriendsRowView(personItem: item)
//                            .padding()
//                    }
//                }
//            }
//        }
//        .ignoresSafeArea(.container, edges: .top)
    }
    
    func convertToPerson(user: FirebaseUser) -> Person {
        return Person(id: user.uid, name: user.name ?? "", email: user.email ?? "")
    }
    
    // MARK: Header
    func HeaderView()->some View {
        
        HStack(spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
//                Text("Today - \(Date().formatted(date: .abbreviated, time: .omitted))")
//                    .foregroundColor(.gray)
                
                Text("People")
                    .font(.largeTitle.bold())
//                    .foregroundColor(.white)
                    .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
            }
            .hLeading()
            
            Button {
                 tabSelection = 5
            } label: {
                FirebaseUserProfileImage()
//                    .resizable()
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

struct Person: Identifiable {
    let id: String
    let name: String
//    let image: URL?
    let email: String
    
    static var person1: Person {
        return Person(
            id: "1",
            name:"Adrian Popescu",
//            image: URL(string: "https://pngset.com/images/brendan-reichs-person-human-face-head-transparent-png-981379.png"),
            email:"adrian.popescu@e-uvt.ro"
            )
    }
    
    static var person2: Person {
        return Person(
            id: "2",
            name:"Andreea Ionescu",
//            image: URL (string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXggOXFdn0mNlS6LsAadJBxrFuXR8M1t9KuA&usqp=CAU"),
            email:"andreea.ionescu00@e-uvt.ro"
            )
    }
    
    static var person3: Person {
        return Person(
            id: "3",
            name:"Maria Georgescu",
//            image: URL (string: "https://image.pngaaa.com/877/4877877-middle.png"),
            email:"maria.georgescu01@e-uvt.ro"
            )
    }
//
//    static var person4: Person {
//        return Person(
//            firstName:"Mihai",
//            lastName: "Albu",
//            image: URL (string: "https://www.vhv.rs/dpng/d/551-5511364_circle-profile-man-hd-png-download.png"),
//            email:"mihai.albu@e-uvt.ro",
//            directions: false
//            )
//    }
//
//    static var person5: Person {
//        return Person(
//            firstName:"Ionela",
//            lastName: "Rosu",
//            image: URL (string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHo2ZyyMTK_nsBZhMGUcOoMtI1U083DKd6EUExMH_AqhC0GUACUazaLnxpgfK0ZhB8n0&usqp=CAU"),
//            email:"ionela.rosu01@e-uvt.ro",
//            directions: false
//            )
//    }
//
//    static var person6: Person {
//        return Person(
//            firstName:"Mirela",
//            lastName: "Negru",
//            image: URL (string: "https://image.pngaaa.com/388/1769388-middle.png"),
//            email:"mirela.negru@e-uvt.ro",
//            directions: false
//            )
//    }
//
//    static var person7: Person {
//        return Person(
//            firstName:"Andrei",
//            lastName: "Negru",
//            image: URL (string: "https://www.vhv.rs/dpng/d/473-4739617_transparent-face-profile-png-round-profile-picture-png.png"),
//            email:"andrei.negru01@e-uvt.ro",
//            directions: false
//            )
//    }
//
//    static var person8: Person {
//        return Person(
//            firstName:"Mircea",
//            lastName: "Rosu",
//            image: URL (string: "https://www.pngfind.com/pngs/m/488-4887957_facebook-teerasej-profile-ball-circle-circular-profile-picture.png"),
//            email:"mircea.rosu01@e-uvt.ro",
//            directions: false
//            )
//    }
}

struct FriendsContentView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsContentView(tabSelection: .constant(1), mapViewModel: MapViewModel(), persons: [.person1, .person2, .person3])
    }
}
