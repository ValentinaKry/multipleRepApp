import Foundation

enum NetworkError: Error, LocalizedError {
    case downloadError(Error?)
    case decoding
    case badRequest
    case noInternet
    var errorDescription: String? {
        switch self {
        case .downloadError:
            return "Something is going wrong. ☃️"
        case .decoding:
            return "Problem with service. /nWe are working with it."
        case .badRequest:
            return "😤 Please wait and try again."
        case .noInternet:
            return "Please check internet connection. And try again. 🏄"
        }
    }
}

struct ErrorType: Error, Identifiable {
    let id = UUID()
    let error: NetworkError
}
