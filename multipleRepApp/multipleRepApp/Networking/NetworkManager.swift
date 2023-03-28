import Foundation

protocol DataSourceManagerProtocol {
    func loadData<T: Codable>(url: Endpoint,
                              completionHandler: @escaping (T) -> Void,
                              errorHandler: @escaping (NetworkError) -> Void)
}

final class NetworkManager: DataSourceManagerProtocol {

    private let session: URLSession

    init(_ session: URLSession = .shared) {
        self.session = session
    }

    private var status: ReachabilityStatus {
        Reach().connectionStatus()
    }

    private func isReachable() -> Bool {
        switch status {
        case .offline, .unknown:
            return false
        case .online:
            return true
        }
    }
    func loadData<T: Codable>(
        url: Endpoint,
        completionHandler: @escaping (T) -> Void,
        errorHandler: @escaping (NetworkError) -> Void
    ) {
        let url = url.url

        if isReachable() {

            request(url: url) { (result: Result<T, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        completionHandler(success)
                    case .failure(let failure):
                        errorHandler(failure)
                    }
                }
            }
        } else {
            errorHandler(.noInternet)
        }
    }

   private func request<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.downloadError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.downloadError(nil)))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                completion(.failure(.badRequest))
                return
            }
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(result))
        }.resume()
    }
}

