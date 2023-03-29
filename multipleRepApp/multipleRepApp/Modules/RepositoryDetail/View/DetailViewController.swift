import UIKit

final class DetailViewController: UIViewController {
    var detailUrl: String

    init(detailUrl: String) {
        self.detailUrl = detailUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("More info here", for: .normal)
        button.setTitleColor(UIColor.systemPink, for: .normal)
        button.addTarget(self, action: #selector(linkTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addAllSubviews()
        setupConstraints()
    }

    private func addAllSubviews() {
        view.addSubview(detailButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc
    private func linkTapped() {
        guard let url = URL(string: detailUrl) else { return }
        UIApplication.shared.openURL(url)
    }
}
