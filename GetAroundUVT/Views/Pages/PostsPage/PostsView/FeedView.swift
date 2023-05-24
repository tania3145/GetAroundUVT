//
//  FeedView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 23.05.2023.
//

import SwiftUI

struct FeedView: View {
    
    var feed: [FeedItem]
    
    var body: some View {
        VStack{
            HStack(spacing: 10) {
                
                VStack(alignment: .leading, spacing: 10) {
//                    Text(Date().formatted(date: .abbreviated, time: .omitted))
//                        .foregroundColor(.gray)
                    
//                    Text("Announcements")
//                    Text("GetAroundUVT Posts")
                    Text("Posts")
                        .font(.largeTitle.bold())
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
            
            ScrollView{
                LazyVStack{
                    ForEach(feed) { item in
                        FeedTileView(feedItem: item)
                            .padding()
                    }
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)

//        .edgesIgnoringSafeArea(.top)
//        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
    }
}

struct FeedItem: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let avatarURL: URL
    let body: String
    let imageURL: URL?
    let location: String
    let directions: Bool
    
    static var demo1: FeedItem {
        return FeedItem(
            name: "Universitatea de Vest din Timișoara",
            email: "@UVT",
            avatarURL: URL(string: "https://scontent.ftsr1-2.fna.fbcdn.net/v/t39.30808-6/332161168_1000877530875022_3115216531097541752_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=Zv7iibYK_TQAX_ebsfT&_nc_ht=scontent.ftsr1-2.fna&oh=00_AfC-Yw7bxzYZ1Wqck5-x9e9wBxPfpP-Hl0kggyV__vJu7g&oe=6472AEB4")!,
            body: "✨ Universitatea de Vest din Timișoara aniversează astăzi 79 de ani de la înființare, marcând astfel un moment deosebit în istoria educației românești.",
            imageURL: URL(string: "https://scontent.ftsr1-2.fna.fbcdn.net/v/t39.30808-6/347243148_763651488736963_6035125559790969760_n.jpg?stp=dst-jpg_p180x540&_nc_cat=104&ccb=1-7&_nc_sid=730e14&_nc_ohc=PV2_T4NmV_UAX--Q8GL&_nc_oc=AQl3EWOWoREyUSiegx5S1JlXtLXw0VX9fqpPKzer0x2_vaZwgQKZD_lWpr6fb5ClYEbQOnumlcCqHbzFqtu-JC36&_nc_ht=scontent.ftsr1-2.fna&oh=00_AfC0OI7yIszVcsetcRIaAMux6Me1TrnLRUKO9fOOuGB9ug&oe=64726BAF"),
            location: "",
            directions: false
        )
    }
    
    static var demo2: FeedItem {
        return FeedItem(
            name: "Maria Ionescu",
            email: "maria.ionescu@e-uvt.ro",
            avatarURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXggOXFdn0mNlS6LsAadJBxrFuXR8M1t9KuA&usqp=CAU")!,
            body: "Dragi studenți, \nSunteți așteptați\n📚 luni, 22 mai, în intervalul\n🕙 orar 10:00-11:00\n📍în amfiteatrul A01\nla atelierul de educație Franco Jobs.\nÎn cadrul acestui eveniment vor participa reprezentanți din diferite companii franco-române care vor prezenta studenților oportunitățile de carieră.",
            imageURL: URL(string: "https://scontent.ftsr1-2.fna.fbcdn.net/v/t39.30808-6/348230912_261675606314883_4005186417571268372_n.jpg?stp=dst-jpg_p180x540&_nc_cat=102&ccb=1-7&_nc_sid=8bfeb9&_nc_ohc=8OqzU2rTg84AX_Tdwim&_nc_ht=scontent.ftsr1-2.fna&oh=00_AfADZm7CHr2Ggj0iQ61-TK0pgv4v5c_hnkNWDBHbgSfvZw&oe=64729BDE"),
            location: "Amfiteatrul A01",
            directions: true
        )
    }
    
    static var demo3: FeedItem {
        return FeedItem(
            name: "Mihai Popescu",
            email: "mihai.popescu@e-uvt.ro",
            avatarURL: URL(string: "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200")!,
            body: "🏆 Weekendul trecut a fost unul foarte bun pentru sportivii noștri, care au câștigat titluri de campion național și au urcat pe podium. \n👏 În clasamentul pe cluburi C.S.U. Universitatea de Vest din Timișoara a obținut locul 2.",
            imageURL: nil,
            location: "",
            directions: false
        )
    }
    
    static var demo4: FeedItem {
        return FeedItem(
            name: "Universitatea de Vest din Timișoara",
            email: "@UVT",
            avatarURL: URL(string: "https://scontent.ftsr1-2.fna.fbcdn.net/v/t39.30808-6/332161168_1000877530875022_3115216531097541752_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=Zv7iibYK_TQAX_ebsfT&_nc_ht=scontent.ftsr1-2.fna&oh=00_AfC-Yw7bxzYZ1Wqck5-x9e9wBxPfpP-Hl0kggyV__vJu7g&oe=6472AEB4")!,
            body: "Vă invităm să descoperiți lumea științei datelor alături de persoane specializate în domeniu, pe care le veți descoperi în cadrul conferinței „Women in Data Science” (în limba engleză), în data de 25 mai, joi, de la ora 09:00-14:00.",
            imageURL: URL(string: "https://scontent.ftsr1-2.fna.fbcdn.net/v/t39.30808-6/348744045_726010759210243_2341737323494028103_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=730e14&_nc_ohc=11bJOmtLbk8AX9_I5BV&_nc_ht=scontent.ftsr1-2.fna&oh=00_AfDqgwc_rCdyG_kj0fToVY1jUmYpzf2Sbf2mn9_84C6TTA&oe=647386C7"),
            location: "Amfiteatrul A02",
            directions: true
        )
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(feed: [.demo1, .demo2, .demo3, .demo4])
    }
}
