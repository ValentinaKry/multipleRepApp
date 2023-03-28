import Foundation

    // https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description
    // https://api.github.com/repositories?
struct Endpoint {

    var host: apiRepo
    var path: apiRepo
    var quertyName: apiRepo
    var quertyValue: apiRepo

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host.host
        components.path = "/" + self.path.path
        components.queryItems = [URLQueryItem(name: self.quertyName.queryItemName, value: self.quertyValue.quertyItemValue)]
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

enum apiRepo {
    case bitBucket
    case gitHub

    var host: String {
        switch self {
        case .bitBucket:
            return "api.bitbucket.org"
        case .gitHub:
            return "api.github.com"
        }
    }

    var path: String {
        switch self {
        case .bitBucket:
            return "2.0/repositories"
        case .gitHub:
            return "repositories"
        }
    }

    var queryItemName: String {
        switch self {
        case .bitBucket:
            return "fields"
        case .gitHub:
            return ""
        }
    }

    var quertyItemValue: String {
        switch self {
        case .bitBucket:
            return "values.name,values.owner,values.description"
        case .gitHub:
            return ""
        }
    }
}

    //
    //enum EndPoint {
    //    case gitHub
    //    case bitBucket
    //
    //    var endPoint: String {
    //        switch self {
    //        case .bitBucket:
    //            return "bitbucket.org/2.0/repositories?"
    //        case .gitHub:
    //            return "githwub.com/"
    //
    //        }
    //    }
    //
    ////    var path: String
    //}
