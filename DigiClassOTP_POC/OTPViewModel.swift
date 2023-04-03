//
//  OTPViewModel.swift
//  DigiClassOTP_POC
//
//  Created by Guru Mahan on 02/03/23.
//

import SwiftUI

class OTPViewModel: ObservableObject {
    
    @Published var number: String = ""
    @Published var code: String = ""
    @Published var otpText: String = ""
    @Published var otpField:[String] = Array(repeating: "", count: 6)
    @Published var isLoading = false
    @Published var verificationCode = ""
    @Published var showAlert: Bool = false
    @Published var errorMsg: String = ""
    @Published var navigationTag: String?
    @AppStorage("log_status") var log_status = false
    
    func sendOTP()async{
        if isLoading {return}
        do{
            DispatchQueue.main.async {
                self.isLoading = true
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.navigationTag = "VERIFICATION"
            }
        }
        catch{
            handelError(error: error.localizedDescription)
        }
    }
    
    func handelError(error: String){
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMsg = error
            self.showAlert.toggle()
        }
    }
    func  verifyOTP() async{
        do{
            DispatchQueue.main.async {
                self.isLoading = true
            }
            var otpString = ""
            for index in otpField {
               otpString += index
            }
                DispatchQueue.main.async {[self] in
                    isLoading = false
                    log_status = true
                }
        }
        catch {
            handelError(error: error.localizedDescription)
        }
    }
}
