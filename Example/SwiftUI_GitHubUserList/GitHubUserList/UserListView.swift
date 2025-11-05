//
//  UserListView.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/10/12.
//

import SwiftUI
import WebKit

struct UserListView: View {
    @Bindable private var viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink(value: user) {
                        UserView(user: user)
                    }
                }
            }
            .task {
                await viewModel.fetch()
            }
            .navigationDestination(for: User.self) { user in
                if #available(iOS 26.0, *) {
                    if let url = URL(string: user.htmlUrl) {
                        WebView(url: url)
                    }
                }
                EmptyView()
            }
            .alert("", isPresented: $viewModel.showAlert) {
                Button("Close", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    UserListView(
        viewModel: UserListViewModel(
            userRepository: UserRepositoryMock()
        )
    )
}
