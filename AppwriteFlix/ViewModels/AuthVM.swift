//
//  AuthViewModel.swift
//  Appwrite Jobs
//
//  Created by Damodar Lohani on 06/10/2021.
//

import Foundation
import Appwrite

class AuthVM: ObservableObject {
    @Published var isLoggedIn = false
    @Published var error: String?
    @Published var user: User?
    
    static let shared = AuthVM()
    
    init() {
        getAccount()
//        AppwriteService.shared.account.updatePrefs(prefs: ["name":"game"])
    }
    
    private func getAccount() {
        error = ""
        AppwriteService.shared.account.get() { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    self.error = err.message
                    self.isLoggedIn = false
                case .success(let user):
                    self.user = user
                    self.isLoggedIn = true
                }
                
            }
        }
    }
    
    func create(name: String, email: String, password: String) {
        error = ""
        AppwriteService.shared.account.create(userId: "unique()", email: email, password: password, name: name) { result in
            switch result {
            case .failure(let err):
                DispatchQueue.main.async {
                    print(err.message)
                    self.error = err.message
                }
            case .success:
                self.login(email: email, password: password)
            }
        }
    }
    
    func logout() {
        error = ""
        AppwriteService.shared.account.deleteSession(sessionId: "current") { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    self.error = err.message
                case .success(_):
                    self.isLoggedIn = false
                    self.error = nil
                }
            }
        }
    }
    
    func loginAnonymous() {
        error = ""
        AppwriteService.shared.account.createAnonymousSession() { result in
            switch result {
            case .failure(let err):
                DispatchQueue.main.async {
                    self.error = err.message
                }
            case .success:
                self.getAccount()
            }
        }
    }
    
    public func login(email: String, password: String) {
        error = ""
        AppwriteService.shared.account.createSession(email: email, password: password) { result in
            switch result {
            case .failure(let err):
                DispatchQueue.main.async {
                    self.error = err.message
                }
            case .success:
                self.getAccount()
            }
        }
    }
    
}
