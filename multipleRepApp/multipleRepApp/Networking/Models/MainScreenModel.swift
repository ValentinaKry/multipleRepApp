import Foundation

struct MainScreenModel {
    var userName: String
    var avatar: String
    var repoTitle: String?
    var repoDescribe: String?
    var repoType: String

    init(userName: String, avatar: String, repoTitle: String?, repoDescribe: String?, repoType: String) {
        self.userName = userName
        self.avatar = avatar
        self.repoTitle = repoTitle
        self.repoDescribe = repoDescribe
        self.repoType = repoType
    }
}
