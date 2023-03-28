import UIKit

final class MainRepositoryViewController: UIViewController {

    private let searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.translatesAutoresizingMaskIntoConstraints = false
        search.searchBar.searchBarStyle = UISearchBar.Style.default
        search.searchBar.placeholder = StringConstants.searchBarPlaceholder
        search.searchBar.sizeToFit()
        search.hidesNavigationBarDuringPresentation = false
        return search
    }()

    private let tableView: DynamicTableView = {
        let tableView = DynamicTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
//        tableView.estimatedRowHeight = 250
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Multiple repository"
        navigationController?.navigationBar.prefersLargeTitles = true
        addAllSubviews()
        setupConstraints()
        setupUI()
        addDatasourceAndDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAppearence()
    }

    private func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func addAllSubviews() {
        view.addSubview(container)
        container.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: container.topAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: ConstrainConstant.tableViewOffset.rawValue ),
            tableView.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -ConstrainConstant.tableViewOffset.rawValue),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }

    func addDatasourceAndDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func prepareForAppearence() {
        navigationController?.isNavigationBarHidden = false
        searchController.searchBar.text = ""
        searchController.searchBar.endEditing(true)
    }

}

extension MainRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RepositoryListTableViewCell else { return UITableViewCell() }
        return cell
    }


}

extension MainRepositoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
}
