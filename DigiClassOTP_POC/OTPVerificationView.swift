//
//  OTPVerificationView.swift
//  DigiClassOTP_POC
//
//  Created by Guru Mahan on 02/03/23.
//

import SwiftUI
struct OTPVerificationView: View {
    
    @StateObject var viewModel = OTPViewModel()
    @FocusState var activated: OTPField?
    @State private var isFocused = true
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("BgImage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                VStack(spacing:80) {
                    VStack(spacing:20){
                        Image("DigiClassLogo")
                        Text("WelCome")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    VStack(){
                        OTpCondition()
                        Button {
                        } label: {
                            Text("VERIFY")
                                .fontWeight(.bold)
                                .frame(width: 180,height: 40)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                        .disabled(checkState())
                        .opacity(checkState() ? 0.4 : 1)
                        .padding(.vertical)
                    }
                }
                .padding()
                .frame(maxHeight: .infinity)
                .navigationTitle("")
                .navigationBarHidden(true)
                .onChange(of: viewModel.otpField) { newValue in
                    OTpCondition(value: newValue)
                }
                .alert(viewModel.errorMsg, isPresented: $viewModel.showAlert) {}
            }
        }
    }
    
    func checkState()-> Bool{
        for index in 0..<6{
            if viewModel.otpField[index].isEmpty{return true}
        }
        return false
    }
    
    func OTpCondition(value:[String]){
        for index in 0..<6{
            if value[index].count == 6{
                DispatchQueue.main.async {
                    viewModel.otpText = value[index]
                    viewModel.otpField[index] = ""
                    for item in viewModel.otpText.enumerated(){
                        viewModel.otpField[item.offset] = String(item.element)
                    }
                }
                return
            }
        }
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activated{
                activated = activeStateForIndex(index: index + 1)
            }
        }
        for index1 in 1...5{
            if value[index1].isEmpty && !value[index1 - 1].isEmpty{
                activated = activeStateForIndex(index: index1 - 1)
            }
        }
        for index1 in 1...5{
            if value[index1].isEmpty && !value[index1 - 1].isEmpty{
                activated = activeStateForIndex(index: index1 - 1)
            }
        }
        for index2 in 0..<6 {
            if value[index2].count > 1{
                if let lst = value[index2].last{
                    viewModel.otpField[index2] = String(lst)
                }
            }
        }
    }
    
    @ViewBuilder func OTpCondition()-> some View{
        HStack(spacing: 14){
            ForEach(0..<6,id: \.self){ index in
                VStack(spacing: 8){
                    TextField("", text: $viewModel.otpField[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .focused($activated, equals: activeStateForIndex(index: index))
                    Rectangle()
                        .fill(activated == activeStateForIndex(index: index) ? .gray : .white)
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
        }
    }
    
    func activeStateForIndex(index: Int)-> OTPField{
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
            
        }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView()
    }
}



enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
