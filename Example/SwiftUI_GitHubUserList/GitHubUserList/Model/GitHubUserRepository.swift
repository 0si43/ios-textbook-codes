//
//  GitHubUserRepository.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/10/12.
//

protocol UserRepository {
    func fetchUsers() async throws -> [User]
}

final class UserRepositoryImpl: UserRepository {
    private let apiClient: GitHubAPIClient
    init(apiClient: GitHubAPIClient) {
        self.apiClient = apiClient
    }

    func fetchUsers() async throws -> [User] {
        try await apiClient.fetchUsers()
    }
}

#if DEBUG
final class UserRepositoryMock: UserRepository {
    private let apiClient: GitHubAPIClient
    init() {
        self.apiClient = GitHubAPIClientMock()
    }

    func fetchUsers() async throws -> [User] {
        [
            User.mock,
            User.mock,
            User.mock
        ]
    }
}
#endif
