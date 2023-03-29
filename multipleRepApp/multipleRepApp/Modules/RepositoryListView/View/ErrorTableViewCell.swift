import UIKit

final class ErrorTableViewCell: UITableViewCell {

    static let cellID = "ErrorTableViewCell"

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sorry, no data about repository"
        label.font = Fonts.headlineBold
        return label
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
        self.contentView.addSubview(label)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: ConstrainConstant.tableCellOffset.rawValue),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: ConstrainConstant.tableCellleadingOffset.rawValue),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -ConstrainConstant.tableCellOffset.rawValue),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -ConstrainConstant.tableCellOffset.rawValue)
        ])
    }
}
