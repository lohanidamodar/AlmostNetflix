//
//  ContentView.swift
//  AppwriteFlix
//
//  Created by Damodar Lohani on 20/12/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthVM

    var body: some View {
        Group {
            if authVM.isLoggedIn {
                HomeView()
                    .environmentObject(MoviesVM(userId: authVM.user!.id))
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut)
        .transition(.move(edge: .bottom))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
