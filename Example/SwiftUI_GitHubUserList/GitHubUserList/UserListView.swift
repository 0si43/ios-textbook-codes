//
//  UserListView.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/10/12.
//

import SwiftUI
import WebKit

struct UserListView: View {
    let userRepository: UserRepository
    @State var users: [User] = []
    @State var errorMessage = ""
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        UserView(user: user)
                    }
                }
            }
            .task {
                do {
                    users = try await userRepository.fetchUsers()
                } catch {
                    errorMessage = error.localizedDescription
                    showAlert = true
                }
            }
            .navigationDestination(for: User.self) { user in
                if #available(iOS 26.0, *) {
                    if let url = URL(string: user.htmlUrl) {
                        WebView(url: url)
                    }
                }
                EmptyView()
            }
            .alert("", isPresented: $showAlert) {
                Button("Close", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    UserListView(userRepository: UserRepositoryMock())
}
