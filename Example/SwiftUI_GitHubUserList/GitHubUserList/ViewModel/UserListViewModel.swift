//
//  UserListViewModel.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/11/05.
//

import Observation

@Observable
final class UserListViewModel {
    let userRepository: UserRepository
    var users: [User] = []
    var errorMessage = ""
    var showAlert = false
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func fetch() async {
        do {
            users = try await userRepository.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
}
