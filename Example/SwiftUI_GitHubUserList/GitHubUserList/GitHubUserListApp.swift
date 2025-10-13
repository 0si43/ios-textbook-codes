//
//  GitHubUserListApp.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/08/05.
//

import SwiftUI

@main
struct GitHubUserListApp: App {
    var body: some Scene {
        WindowGroup {
            UserListView(
                userRepository: UserRepositoryImpl(
                    apiClient: GitHubAPIClientImpl()
                )
            )
        }
    }
}
