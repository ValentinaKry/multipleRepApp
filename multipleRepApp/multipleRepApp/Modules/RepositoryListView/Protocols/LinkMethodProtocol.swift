import Foundation

protocol LinkMethodProtocol {
    func getDetailViewController(didSelectRowAt indexPath: IndexPath) -> DetailViewController?
}
