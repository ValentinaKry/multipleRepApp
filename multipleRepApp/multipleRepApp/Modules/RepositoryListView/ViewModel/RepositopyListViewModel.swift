import Foundation

final class RepositopyListViewModel: TableViewProvidingProtocol, SearchProvidingProtocol, LinkMethodProtocol {

    var reloadTable: (() -> Void)?
    var retryCompletion: ((String?) -> Void)?
    private var networkManager: DataSourceManagerProtocol
    private var gitHubResult = [GitHubModel]()
    private var bitBucketResult : BitBucketModel?
    private var repoResults: MainScreenModel?
    private var allRepoResults = [MainScreenModel]() {
        didSet {
            filteredArrayData = allRepoResults
        }
    }
    private var filteredArrayData = [MainScreenModel]()

    init(networkManager: DataSourceManagerProtocol) {
        self.networkManager = networkManager
    }

    func loadData() {
        let group = DispatchGroup()
        let url = Endpoint(host: .gitHub, path: .gitHub, quertyName: .gitHub, quertyValue: .gitHub)
        networkManager.loadData(url: url) { [weak self] (item: [GitHubModel]) in
            guard let self = self else { return }
            self.allRepoResults.removeAll()
            self.gitHubResult = item
            group.enter()
            self.loadBitBuckedData {
                group.leave()
            }
            group.notify(queue: .main) {
                self.reloadTable?()
            }
        } errorHandler: { errorMessage in
            self.retryCompletion?(errorMessage.errorDescription)
        }
    }

    private func loadBitBuckedData(completion: @escaping (() -> Void)) {
        let url = Endpoint(host: .bitBucket, path: .bitBucket, quertyName: .bitBucket, quertyValue: .bitBucket)
        networkManager.loadData(url: url) { [weak self] (item: BitBucketModel) in
            guard let self = self
            else { return }
            self.bitBucketResult = item
            self.prepareData()
            completion()
        } errorHandler: { errorMessage in
            self.retryCompletion?(errorMessage.errorDescription)
        }

    }

    private func prepareData() {
        for element in gitHubResult {
            let repoResults = MainScreenModel(userName: element.fullName,
                                              avatar: element.owner.avatarURL,
                                              repoTitle: element.fullName,
                                              repoDescribe: element.description,
                                              repoType: "Github",
                                              detailLink: element.owner.htmlURL)
            allRepoResults.append(repoResults)
        }
        guard let bitBucketData = bitBucketResult?.values else { return }
        for element in bitBucketData {
            let repoResults = MainScreenModel(userName: element.owner.displayName,
                                              avatar: element.owner.links.avatar.href,
                                              repoTitle: element.owner.nickname,
                                              repoDescribe: element.description,
                                              repoType: "Bitbucket",
                                              detailLink: element.owner.links.html.href)
            allRepoResults.append(repoResults)
        }
    }

    func amountOfCells() -> Int? {
        filteredArrayData.count
    }

    func getDataResult(cellForRowAt indexPath: IndexPath) -> MainScreenModel? {
        guard !filteredArrayData.isEmpty,
              indexPath.row <= filteredArrayData.count
                
        else { return nil }
        return filteredArrayData[indexPath.row]
    }

    func filteredData(searchText: String) {
        guard !searchText.isEmpty  else {
        filteredArrayData = allRepoResults
            return
        }
        filteredArrayData = allRepoResults.filter{ data in
            data.userName.contains(searchText)
        }
    }

    func createLink() -> URL {
        guard let url = URL(string: filteredArrayData[0].detailLink) else { fatalError() }
        return url
    }

    func getDetailViewController(didSelectRowAt indexPath: IndexPath) -> DetailViewController? {
           let stringURL = filteredArrayData[indexPath.row].detailLink
           let datailVC = DetailViewController(detailUrl: stringURL)
           return datailVC
       }
}
