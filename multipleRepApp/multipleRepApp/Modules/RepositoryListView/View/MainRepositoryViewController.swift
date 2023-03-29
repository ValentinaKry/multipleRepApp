import UIKit

final class MainRepositoryViewController: UIViewController {
    
    var viewModel: TableViewProvidingProtocol & SearchProvidingProtocol & LinkMethodProtocol
    
    init(viewModel: TableViewProvidingProtocol & SearchProvidingProtocol & LinkMethodProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let tableView = DynamicTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: RepositoryListTableViewCell.cellID)
        tableView.register(ErrorTableViewCell.self, forCellReuseIdentifier: ErrorTableViewCell.cellID)
        return tableView
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loaderIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemPink
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Multiple repository"
        navigationController?.navigationBar.prefersLargeTitles = true
        addAllSubviews()
        setupConstraints()
        setupTableView()
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
        container.addSubview(loaderIndicatorView)
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
            
            loaderIndicatorView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            loaderIndicatorView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func addDatasourceAndDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchBar.delegate = self
    }
    
    private func prepareForAppearence() {
        navigationController?.isNavigationBarHidden = false
        searchController.searchBar.text = ""
        searchController.searchBar.endEditing(true)
    }
    
    private func setupTableView() {
        loaderIndicatorView.startAnimating()
        viewModel.reloadTable = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loaderIndicatorView.stopAnimating()
            }
        }
        viewModel.retryCompletion = { [weak self] message in
            guard let message = message,
                  let self = self
            else { return }
            DispatchQueue.main.async {
                let alert = self.alertBuilder(
                    message: message,
                    completion: {
                        self.viewModel.retry()
                    }
                )
                self.present(alert, animated: true)
            }
        }
        viewModel.loadData()
    }
    
}

extension MainRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let result = viewModel.amountOfCells() else { return 1 }
            // If there's no events, return 1 cell, with info label
        if result == 0 {
            return 1
        } else {
            return  result
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let resultOfData = viewModel.amountOfCells() else { return UITableViewCell() }
        if resultOfData == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ErrorTableViewCell.cellID,
                for: indexPath) as? ErrorTableViewCell
            else { return UITableViewCell() }
            return cell
        } else { 
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListTableViewCell.cellID, for: indexPath) as? RepositoryListTableViewCell,
                   let data = viewModel.getDataResult(cellForRowAt: indexPath)
            else { return UITableViewCell() }
            cell.configure(with: data)
            cell.accessoryType = .disclosureIndicator
            
            return cell

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = viewModel.getDetailViewController(didSelectRowAt: indexPath) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainRepositoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredData(searchText: searchText)
        tableView.reloadData()
    }
}
