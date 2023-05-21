//
//  CustomTextFieldView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 21.05.2023.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct CustomTextFieldView: View {
    @Binding var text: String
    @State var placeholder: String
    @State var icon: String
    @State var isSecure: Bool = false
    @State var autoCap: TextInputAutocapitalization = .never
    
    var body: some View {
        VStack() {
            HStack(spacing: 15){
                Image(systemName: icon)
                    .foregroundColor(Color("Color"))
                let textField = isSecure ? AnyView(SecureField("", text: self.$text)) : AnyView(TextField("", text: self.$text))
                textField
                    .textInputAutocapitalization(autoCap)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
            }
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
    }
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTextFieldView(text: .constant(""), placeholder: "Type something", icon: "envelope.fill")
            Spacer()
        }.background(.blue)
    }
}
