/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

extension UIViewController {
    func add(childViewController child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func removeSelf() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
