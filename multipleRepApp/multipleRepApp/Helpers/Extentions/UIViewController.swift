import UIKit
extension UIViewController {
    var status: ReachabilityStatus {
        Reach().connectionStatus()
    }

    func alertBuilder(message: String, completion: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { _ in
            completion?()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        return alert
    }
}

