//
//  SearchBarWidget.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 18.04.2023.
//

import SwiftUI


struct SearchBarWidget: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("", text: $text)
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.trailing, 8)
                .overlay(
                    Text("Search")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                        .padding(.trailing, 2)
                        .opacity(100)
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct SearchBarWidget_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarWidget(text: .constant(""))
    }
}
