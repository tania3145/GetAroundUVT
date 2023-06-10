//
//  FriendsContentView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 08.06.2023.
//

import SwiftUI

struct FriendsContentView: View{   
    var person: [Person]
    
    var body: some View {
        VStack{
            HStack(spacing: 10) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("People")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
                }
                .hLeading()
            }
            .padding()
            .padding(.top, getSafeArea().top)

            .background(Color.white)
            
            ScrollView{
                LazyVStack{
                    ForEach(person) { item in
                        FriendsRowView(personItem: item)
                            .padding()
                    }
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

struct Person: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let image: URL?
    let email: String
    let directions: Bool
    
    static var person1: Person {
        return Person(
            firstName:"Adrian",
            lastName: "Popescu",
            image: URL(string: "https://pngset.com/images/brendan-reichs-person-human-face-head-transparent-png-981379.png"),
            email:"adrian.popescu@e-uvt.ro",
            directions: false
            )
    }
    
    static var person2: Person {
        return Person(
            firstName:"Andreea",
            lastName: "Ionescu",
            image: URL (string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXggOXFdn0mNlS6LsAadJBxrFuXR8M1t9KuA&usqp=CAU"),
            email:"andreea.ionescu00@e-uvt.ro",
            directions: false
            )
    }
    
    static var person3: Person {
        return Person(
            firstName:"Maria",
            lastName: "Georgescu",
            image: URL (string: "https://image.pngaaa.com/877/4877877-middle.png"),
            email:"maria.georgescu01@e-uvt.ro",
            directions: false
            )
    }
    
    static var person4: Person {
        return Person(
            firstName:"Mihai",
            lastName: "Albu",
            image: URL (string: "https://www.vhv.rs/dpng/d/551-5511364_circle-profile-man-hd-png-download.png"),
            email:"mihai.albu@e-uvt.ro",
            directions: false
            )
    }
    
    static var person5: Person {
        return Person(
            firstName:"Ionela",
            lastName: "Rosu",
            image: URL (string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHo2ZyyMTK_nsBZhMGUcOoMtI1U083DKd6EUExMH_AqhC0GUACUazaLnxpgfK0ZhB8n0&usqp=CAU"),
            email:"ionela.rosu01@e-uvt.ro",
            directions: false
            )
    }
    
    static var person6: Person {
        return Person(
            firstName:"Mirela",
            lastName: "Negru",
            image: URL (string: "https://image.pngaaa.com/388/1769388-middle.png"),
            email:"mirela.negru@e-uvt.ro",
            directions: false
            )
    }
    
    static var person7: Person {
        return Person(
            firstName:"Andrei",
            lastName: "Negru",
            image: URL (string: "https://www.vhv.rs/dpng/d/473-4739617_transparent-face-profile-png-round-profile-picture-png.png"),
            email:"andrei.negru01@e-uvt.ro",
            directions: false
            )
    }
    
    static var person8: Person {
        return Person(
            firstName:"Mircea",
            lastName: "Rosu",
            image: URL (string: "https://www.pngfind.com/pngs/m/488-4887957_facebook-teerasej-profile-ball-circle-circular-profile-picture.png"),
            email:"mircea.rosu01@e-uvt.ro",
            directions: false
            )
    }
}

struct FriendsContentView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsContentView(person: [.person1, .person2, .person3, .person4, .person5, .person6, .person7, .person8])
    }
}
