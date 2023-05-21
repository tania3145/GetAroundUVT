//
//  LoginSignupView.swift
//  GetAroundUVT
//
//  Created by Tania Maria on 21.05.2023.
//

import SwiftUI

enum FormField: Hashable {
    case loginEmailField
    case loginPasswordField
    case registerNameField
    case registerEmailField
    case registerPasswordField
    case registerConfirmPasswordField
}

struct LoginSignupView: View {
    @State var navigateToMainMenu : Bool = false
    @State var navigateToRegister : Bool = false
    @State var index = 0
    @FocusState private var focusedField: FormField?
    
    @ViewBuilder
    var body: some View {
        GeometryReader{_ in
            VStack{
                Spacer()
                
                Image("logoUVT")
                    .resizable()
                    .frame(width: 150, height: 130)
                    
                ZStack{
                    SignupView(index: self.$index, focusedField: $focusedField)
                        // changing view order
                        .zIndex(Double(self.index))
                    LoginView(index: self.$index, focusedField: $focusedField)
                }
                
                HStack(spacing: 15){
                    Rectangle()
                    .fill(Color("Color 1"))
                    .frame(height: 2)
                    
                    Text("OR")
                    .foregroundColor(.white)
                    
                    Rectangle()
                    .fill(Color("Color 1"))
                    .frame(height: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50) // because login button is moved 25 in y axis and 25 padding = 50
                
                HStack(spacing: 25){
                    Button(action: {
                        
                    }) {
                        Image("facebook")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image("google")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    }
                }
                .padding(.vertical)
            }
            .background(Color("Color 3").edgesIgnoringSafeArea(.all))
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
}

// Login Page
struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @Binding var index : Int
    var focusedField: FocusState<FormField?>.Binding

    var body: some View{
        ZStack(alignment: .bottom) {
            VStack{
                HStack{
                    VStack(spacing: 8){
                        Text("Log In")
                            .foregroundColor(self.index == 0 ? .white : .white.opacity(0.5))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 0 ? Color(red: 0.859, green: 0.678, blue: 0.273) : Color.clear) // UVT color
                            .frame(width: 100, height: 5)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 30) // for top curve
                
                VStack {
                    CustomTextFieldView(text: $email, placeholder: "Email Address", icon: "envelope.fill")
                        .keyboardType(.emailAddress)
                        .focused(focusedField, equals: .loginEmailField)
                        .submitLabel(.next)
                        .padding(.top, 70)
                    
                    CustomTextFieldView(text: $password, placeholder: "Password", icon: "eye.slash.fill", isSecure: true)
                        .focused(focusedField, equals: .loginPasswordField)
                        .padding(.top, 30)
                        .submitLabel(.done)
                }.onSubmit {
                    switch focusedField.wrappedValue {
                        case .loginEmailField:
                            focusedField.wrappedValue = .loginPasswordField
                        default:
                        focusedField.wrappedValue = nil
                    }
                }
                
                HStack{
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }) {
                        Text("Don't have an account? Sign Up!")
                            .foregroundColor(Color.white.opacity(0.9))
                    }
                }
                .padding(.vertical)
                .padding(.top, 10)
                
                HStack{
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }) {
                        Text("Forget Password?")
                            .foregroundColor(Color.white.opacity(0.9))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
            }
            .padding()
            // button padding
            .padding(.bottom, 65)
            .background(Color("Color 2"))
            .clipShape(CShape())
            // clipping the content shape also for tap gesture
            .contentShape(CShape())
            // shadow
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            // Button
            Button(action: {
                
            }) {
                Text("LOG IN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color 1"))
                    .clipShape(Capsule())
                    // shadow
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            // moving view down
            .offset(y: 25)
            // hiding view when  its in background
            .opacity(self.index == 0 ? 1 : 0)
        }
    }
}

// Curve
struct CShape: Shape {
    func path(in rect: CGRect) -> SwiftUI.Path {
        return SwiftUI.Path{path in
            
            // right side curve
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

// Signup Page
struct SignupView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var rePassword = ""
    @Binding var index : Int
    var focusedField: FocusState<FormField?>.Binding
    
    var body: some View{
        ZStack(alignment: .bottom){
            VStack{
                HStack{
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 10){
                        Text("Sign Up")
                            .foregroundColor(self.index == 1 ? .white : .white.opacity(0.5))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 1 ? Color(red: 0.859, green: 0.678, blue: 0.273) : Color.clear) // UVT color
                            .frame(width: 100, height: 5)
                    }
                }
                .padding(.top, 30) // for top curve...
                
                VStack {
                    CustomTextFieldView(text: $name, placeholder: "Name", icon: "person.crop.circle.badge.fill", autoCap: .sentences)
                        .focused(focusedField, equals: .registerNameField)
                        .submitLabel(.next)
                        .padding(.top, 40)
                    
                    CustomTextFieldView(text: $email, placeholder: "Email Address", icon: "envelope.fill")
                        .keyboardType(.emailAddress)
                        .focused(focusedField, equals: .registerEmailField)
                        .submitLabel(.next)
                        .padding(.top, 30)
                    
                    CustomTextFieldView(text: $password, placeholder: "Password", icon: "eye.slash.fill", isSecure: true)
                        .focused(focusedField, equals: .registerPasswordField)
                        .padding(.top, 30)
                        .submitLabel(.next)
                    
                    CustomTextFieldView(text: $rePassword, placeholder: "Confirm Password", icon: "eye.slash.fill", isSecure: true)
                        .focused(focusedField, equals: .registerConfirmPasswordField)
                        .padding(.top, 30)
                        .submitLabel(.done)
                }.onSubmit {
                    switch focusedField.wrappedValue {
                        case .registerNameField:
                            focusedField.wrappedValue = .registerEmailField
                        case .registerEmailField:
                            focusedField.wrappedValue = .registerPasswordField
                        case .registerPasswordField:
                            focusedField.wrappedValue = .registerConfirmPasswordField
                        default:
                            focusedField.wrappedValue = nil
                    }
                }
                
            }
            .padding()
            // button padding
            .padding(.bottom, 65)
            .background(Color("Color 2"))
            .clipShape(CShape1())
            // clipping the content shape also for tap gesture
            .contentShape(CShape1())
            // shadow
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            // Button
            Button(action: {
                
            }) {
                Text("SIGN UP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color 1"))
                    .clipShape(Capsule())
                    // shadow
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            // moving view down
            .offset(y: 25)
            // hiding view when  its in background
            .opacity(self.index == 1 ? 1 : 0)
        }
    }
}

// Curve
struct CShape1: Shape {
    func path(in rect: CGRect) -> SwiftUI.Path {
        return SwiftUI.Path{path in
            
            // left side curve
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
    }
}
