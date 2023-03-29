import Foundation

protocol TableViewProvidingProtocol {
    var reloadTable: (() -> Void)? { get set }
    var retryCompletion: ((String?) -> Void)? { get set }

    func loadData()
    func amountOfCells() -> Int?
    func getDataResult(cellForRowAt indexPath: IndexPath) -> MainScreenModel?
}

extension TableViewProvidingProtocol {
    func retry() {
        loadData()
    }
}
