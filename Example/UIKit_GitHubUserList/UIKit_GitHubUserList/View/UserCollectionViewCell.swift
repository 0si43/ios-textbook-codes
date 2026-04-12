import UIKit

final class UserCollectionViewCell: UICollectionViewCell {
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .systemGray4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    private var imageTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let labelStack = UIStackView(arrangedSubviews: [loginLabel, idLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 2
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(avatarImageView)
        contentView.addSubview(labelStack)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            labelStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            labelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    func configure(with user: User) {
        loginLabel.text = user.login
        idLabel.text = String(user.id)
        loadAvatar(from: user.avatarUrl)
    }

    private func loadAvatar(from urlString: String) {
        imageTask?.cancel()
        avatarImageView.image = nil
        imageTask = Task { [weak self] in
            guard let url = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data),
                  !Task.isCancelled else { return }
            self?.avatarImageView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        avatarImageView.image = nil
        loginLabel.text = nil
        idLabel.text = nil
    }
}
