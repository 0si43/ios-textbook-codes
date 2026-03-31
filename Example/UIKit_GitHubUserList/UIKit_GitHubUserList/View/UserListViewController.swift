import UIKit

final class UserListViewController: UIViewController {

    private let viewModel: UserListViewModel
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<String, User>!

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Users"
        setupCollectionView()
        setupDataSource()
        loadUsers()
    }

    private func setupCollectionView() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        collectionView.delegate = self
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, User> { cell, _, user in
            cell.configure(with: user)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { cv, indexPath, user in
            cv.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: user)
        }
    }

    private func loadUsers() {
        Task {
            await viewModel.fetch()
            if viewModel.showAlert {
                let alert = UIAlertController(
                    title: nil,
                    message: viewModel.errorMessage,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "閉じる", style: .cancel))
                present(alert, animated: true)
            } else {
                var snapshot = NSDiffableDataSourceSnapshot<String, User>()
                snapshot.appendSections(["main"])
                snapshot.appendItems(viewModel.users)
                await dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }
}

extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let user = dataSource.itemIdentifier(for: indexPath),
              let url = URL(string: user.htmlUrl) else { return }
        navigationController?.pushViewController(WebViewController(url: url), animated: true)
    }
}
