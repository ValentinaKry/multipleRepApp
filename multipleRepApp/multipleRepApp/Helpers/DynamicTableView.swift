import UIKit

final class DynamicTableView: UITableView {

    override var intrinsicContentSize: CGSize {
        contentSize
    }

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
}
