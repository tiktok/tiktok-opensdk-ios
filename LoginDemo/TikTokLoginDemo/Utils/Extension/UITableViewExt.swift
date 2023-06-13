/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
extension UITableView {

    func indexPath(after indexPath: IndexPath) -> IndexPath? {
        var row = indexPath.row + 1
        for section in indexPath.section..<numberOfSections {
            if row < numberOfRows(inSection: section) {
                return IndexPath(row: row, section: section)
            }
            row = 0
        }
        return nil
    }

    func indexPath(before indexPath: IndexPath) -> IndexPath? {
        var row = indexPath.row - 1
        for section in (0...indexPath.section).reversed() {
            if row >= 0 {
                return IndexPath(row: row, section: section)
            }
            if section > 0 {
                row = numberOfRows(inSection: section - 1) - 1
            }
        }
        return nil
    }

}
