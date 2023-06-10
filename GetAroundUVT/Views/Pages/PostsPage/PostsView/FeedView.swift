//
//  FeedView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 23.05.2023.
//

import SwiftUI

struct FeedView: View {
    @Binding var tabSelection: Int
    @StateObject var mapViewModel: MapViewModel
    @State var feed: [FeedItem] = []
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Exception occurred"
    @State var alertMessage: String = ""
    
    // MARK: Header
    func HeaderView()->some View {
        
        HStack(spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
//                Text("Today - \(Date().formatted(date: .abbreviated, time: .omitted))")
//                    .foregroundColor(.gray)
                
                Text("Posts")
                    .font(.largeTitle.bold())
//                    .foregroundColor(.white)
                    .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
            }
            .hLeading()
            
            Button {
                 tabSelection = 5
            } label: {
//                Image("Profile")
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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    VStack {
                        ScrollView{
                            LazyVStack{
                                ForEach(feed) { item in
                                    FeedTileView(tabSelection: $tabSelection, mapViewModel: mapViewModel, feedItem: item)
                                        .padding()
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
            let service = NavigationService.Instance()
            DispatchQueue.main.async {
                Task {
                    do {
                        feed = try await service.getPosts()
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
//        VStack {
//            HStack(spacing: 10) {
//
//                VStack(alignment: .leading, spacing: 10) {
//
//                    Text("Posts")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(Color(red: 0.115, green: 0.287, blue: 0.448)) // Dark Blue UVT Color
//                }
//                .hLeading()
//            }
//            .padding()
//            .padding(.top, getSafeArea().top)
//            .background(Color.white)
//
//            ScrollView{
//                LazyVStack{
//                    ForEach(feed) { item in
//                        FeedTileView(feedItem: item)
//                            .padding()
//                    }
//                }
//            }
//        }
////        .ignoresSafeArea(.container, edges: .top)
//        .onAppear() {
//            let service = NavigationService.Instance()
//            DispatchQueue.main.async {
//                Task {
//                    do {
//                        feed = try await service.getPosts()
//                    } catch {
//                        showAlert = true
//                        alertMessage = "\(error)"
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text(alertTitle),
//                message: Text(alertMessage),
//                dismissButton: .default(Text("OK"))
//            )
//
//            //        .edgesIgnoringSafeArea(.top)
//            //        .background(Color(red: 0.115, green: 0.287, blue: 0.448))
//        }
    }
}

struct FeedItem: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let avatarURL: URL
    let body: String
    let imageURL: URL?
    
    static var demo1: FeedItem {
        return FeedItem(
            name: "Universitatea de Vest din Timișoara",
            email: "@UVT",
            avatarURL: URL(string: "https://scontent.fsbz1-2.fna.fbcdn.net/v/t39.30808-6/332161168_1000877530875022_3115216531097541752_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=mc13VMUzqqkAX9T6-7k&_nc_ht=scontent.fsbz1-2.fna&oh=00_AfBmbt1Gtl0eUmG-PM6t1-d7pc7nTDn4yZq9--qtQp5bdQ&oe=64867534")!,
            body: "✨ Universitatea de Vest din Timișoara aniversează astăzi 79 de ani de la înființare, marcând astfel un moment deosebit în istoria educației românești.",
            imageURL: URL(string: "https://www.ziuadevest.ro/wp-content/uploads/2022/06/UVT.jpg")
//            location: "",
//            directions: false
        )
    }
    
    static var demo2: FeedItem {
        return FeedItem(
            name: "Maria Ionescu",
            email: "maria.ionescu@e-uvt.ro",
            avatarURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXggOXFdn0mNlS6LsAadJBxrFuXR8M1t9KuA&usqp=CAU")!,
            body: "Dragi studenți, \nSunteți așteptați\n📚 luni, 22 mai, în intervalul\n🕙 orar 10:00-11:00\n📍în amfiteatrul A01\nla atelierul de educație Franco Jobs.\nÎn cadrul acestui eveniment vor participa reprezentanți din diferite companii franco-române care vor prezenta studenților oportunitățile de carieră.",
            imageURL: URL(string: "https://timisplus.ro/wp-content/uploads/2021/10/ioan.t.morar_.uvt_.png")
//            location: "Amfiteatrul A01",
//            directions: true
        )
    }
    
    static var demo3: FeedItem {
        return FeedItem(
            name: "Mihai Popescu",
            email: "mihai.popescu@e-uvt.ro",
            avatarURL: URL(string: "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200")!,
            body: "🏆 Weekendul trecut a fost unul foarte bun pentru sportivii noștri, care au câștigat titluri de campion național și au urcat pe podium. \n👏 În clasamentul pe cluburi C.S.U. Universitatea de Vest din Timișoara a obținut locul 2.",
            imageURL: nil
//            location: "",
//            directions: false
        )
    }
    
    static var demo4: FeedItem {
        return FeedItem(
            name: "Universitatea de Vest din Timișoara",
            email: "@UVT",
            avatarURL: URL(string: "https://scontent.fsbz1-2.fna.fbcdn.net/v/t39.30808-6/332161168_1000877530875022_3115216531097541752_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=mc13VMUzqqkAX9T6-7k&_nc_ht=scontent.fsbz1-2.fna&oh=00_AfBmbt1Gtl0eUmG-PM6t1-d7pc7nTDn4yZq9--qtQp5bdQ&oe=64867534")!,
            body: "Vă invităm să descoperiți lumea științei datelor alături de persoane specializate în domeniu, pe care le veți descoperi în cadrul conferinței „Women in Data Science” (în limba engleză), în data de 25 mai, joi, de la ora 09:00-14:00.",
            imageURL: URL(string: "https://scontent.fsbz1-1.fna.fbcdn.net/v/t39.30808-6/348744045_726010759210243_2341737323494028103_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=730e14&_nc_ohc=2xgh05QEGnMAX-WV1sw&_nc_ht=scontent.fsbz1-1.fna&oh=00_AfAkVzuwmqsWuGshkCbvG-7pnv_CFstx8WCPG0SJ6xzbog&oe=64874D47")
//            location: "Amfiteatrul A02",
//            directions: true
        )
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(tabSelection: .constant(1), mapViewModel: MapViewModel(), feed: [.demo1, .demo2, .demo3, .demo4])
    }
}
