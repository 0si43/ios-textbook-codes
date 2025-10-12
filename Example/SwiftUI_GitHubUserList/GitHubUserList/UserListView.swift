//
//  UserListView.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/10/12.
//

import SwiftUI

struct UserListView: View {
    let userRepository: UserRepository
    @State var users: [User] = []
    
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
                    // error
                }
            }
            .navigationDestination(for: User.self) { user in
                // detail view
            }
        }
    }
}

#Preview {
    UserListView(userRepository: UserRepositoryMock())
}
