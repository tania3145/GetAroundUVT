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

class TextFieldItem : ObservableObject {
    @Published var value: String = ""
    @Published var errorMessage: String = ""
    private var validateF: (TextFieldItem) -> Bool = {_ in true}
    
    convenience init(validate: @escaping (TextFieldItem) -> Bool = {_ in true}) {
        self.init(value: "", errorMessage: "", validate: validate)
    }
    
    init(value: String, errorMessage: String, validate: @escaping (TextFieldItem) -> Bool = {_ in true}) {
        self.value = value
        self.errorMessage = errorMessage
        self.validateF = validate
    }
    
    func HasError() -> Bool {
        return !errorMessage.isEmpty
    }
    
    func validate() -> Bool {
        return validateF(self)
    }
}

struct CustomTextFieldView: View {
    @ObservedObject var fieldItem: TextFieldItem
    @State var placeholder: String
    @State var icon: String
    @State var isSecure: Bool = false
    @State var autoCap: TextInputAutocapitalization = .never
    
    var body: some View {
        VStack() {
            HStack(spacing: 15){
                Image(systemName: icon)
                    .foregroundColor(Color("Color"))
                let textField = isSecure ? AnyView(SecureField("", text: $fieldItem.value)) : AnyView(TextField("", text: $fieldItem.value))
                textField
                    .textInputAutocapitalization(autoCap)
                    .placeholder(when: fieldItem.value.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
                    .onChange(of: fieldItem.value) { _ in
                        _ = fieldItem.validate()
                    }
            }
            Divider().background(Color.white.opacity(0.5))
            if fieldItem.HasError() {
                HStack{
                    Text(fieldItem.errorMessage)
                        .foregroundColor(.red)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTextFieldView(fieldItem: TextFieldItem(value: "Hello", errorMessage: ""), placeholder: "Type something", icon: "envelope.fill")
            Spacer()
        }.background(.blue)
    }
}
