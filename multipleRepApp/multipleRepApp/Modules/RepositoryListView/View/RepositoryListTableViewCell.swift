import UIKit

final class RepositoryListTableViewCell: UITableViewCell {

//    static let cellID = "RepositoryListTableViewCell"

    private let repoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.headlineBold
        label.text = "CCCCCCCCCC"
        return label
    }()

    private let repoDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.headlineMedium
        label.text = "Texttext-text-text"
        return label
    }()

    private let repoTag: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.smallTitleFontSemiBold
        label.text = "HubBub"
        return label
    }()

    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.image = UIImage(named: "Mock")
        return image
    }()

    private lazy var descibeRepoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [repoTitle, repoDescription, repoTag])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareSubviews() {
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(descibeRepoStack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            descibeRepoStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            descibeRepoStack.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: ConstrainConstant.tableCellOffset.rawValue),
            descibeRepoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descibeRepoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarImage.widthAnchor.constraint(equalToConstant: 50),
            avatarImage.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configure() {

    }
}
