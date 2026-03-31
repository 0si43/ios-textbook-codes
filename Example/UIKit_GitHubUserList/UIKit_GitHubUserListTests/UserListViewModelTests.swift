import Testing
@testable import UIKit_GitHubUserList
import Foundation

private final class UserRepositoryStub: @unchecked Sendable, UserRepository {
    var fetchHandler: () async throws -> [User] = { [] }

    func fetchUsers() async throws -> [User] {
        try await fetchHandler()
    }
}

@MainActor
struct UserListViewModelTests {
    init() {
        // 各テストケース開始前に行いたい処理
    }

//    各テストケース終了後に処理をさせたい場合は、UserListViewModelTestsをclassかactorにして、deinitで処理する
//    deinit {
//
//    }

    @Test
    func fetchSuccess() async {
        let expectedUsers = [
            User(login: "user1", id: 1, avatarUrl: "https://example.com/1.png", htmlUrl: "https://github.com/user1"),
            User(login: "user2", id: 2, avatarUrl: "https://example.com/2.png", htmlUrl: "https://github.com/user2"),
        ]
        let stub = UserRepositoryStub()
        stub.fetchHandler = { expectedUsers }
        let viewModel = UserListViewModel(userRepository: stub)

        await viewModel.fetch()

        #expect(viewModel.users == expectedUsers)
        #expect(viewModel.showAlert == false)
        #expect(viewModel.errorMessage.isEmpty)
    }

    @Test
    func fetchFailure() async {
        struct TestError: LocalizedError {
            var errorDescription: String? { "Something went wrong" }
        }
        let stub = UserRepositoryStub()
        stub.fetchHandler = { throw TestError() }
        let viewModel = UserListViewModel(userRepository: stub)

        await viewModel.fetch()

        #expect(viewModel.users.isEmpty)
        #expect(viewModel.showAlert == true)
        #expect(viewModel.errorMessage == "Something went wrong")
    }
}
