import Foundation

final class RepositopyListViewModel: TableViewProvidingProtocol {
    var reloadTable: (() -> Void)?
    var retryCompletion: ((String?) -> Void)?
    private var networkManager: DataSourceManagerProtocol
    private var gitHubResult = [GitHubModel]()
    private var bitBucketResult = [BitBucketModel]()
    private var repoResults: MainScreenModel?
    private var allRepoResults = [MainScreenModel?]()


    init(networkManager: DataSourceManagerProtocol) {
        self.networkManager = networkManager
    }

    func loadData() {
        let group = DispatchGroup()
        let url = Endpoint(host: .gitHub, path: .gitHub, quertyName: .gitHub, quertyValue: .gitHub)
        networkManager.loadData(url: url) { [weak self] (item: [GitHubModel]) in
            guard let self = self else { return }
            for element in item {
                self.repoResults?.userName = element.fullName
                self.repoResults?.avatar = element.owner.avatarURL
                self.repoResults?.repoDescribe = element.description
                self.repoResults?.repoTitle = element.fullName
                self.repoResults?.repoType = "Github"
                self.allRepoResults.append(self.repoResults)
            }
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
            for element in item.values {
                self.repoResults?.userName = element.owner.displayName
                self.repoResults?.repoDescribe = element.description
                self.repoResults?.avatar = element.owner.links.avatar.href
                self.repoResults?.repoTitle = element.owner.nickname
                self.repoResults?.repoType = "Bitbucket"
                
            }
        } errorHandler: { errorMessage in
            self.retryCompletion?(errorMessage.errorDescription)
        }

    }

    func amountOfCells() -> Int? {
        allRepoResults.count
    }

    func getDataResult(cellForRowAt indexPath: IndexPath) -> MainScreenModel? {
        guard !allRepoResults.isEmpty,
              indexPath.row <= allRepoResults.count
        else { return nil }
        return allRepoResults[indexPath.row]
    }
}
