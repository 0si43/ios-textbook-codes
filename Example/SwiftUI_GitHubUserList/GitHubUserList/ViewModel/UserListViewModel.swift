//
//  UserListViewModel.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/11/05.
//

import Observation
import Foundation

@MainActor @Observable
final class UserListViewModel {
    var users: [User] = []
    var errorMessage = ""
    var showAlert = false

    @ObservationIgnored let userRepository: UserRepository
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
