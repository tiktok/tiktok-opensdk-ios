/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class MetaInfoListViewController: ListViewController<MetaInfoListItem, MetaInfoListSection, MetaInfoListViewModel> {
    override var cellIdTypeDict: [String: ListBaseCell<MetaInfoListItem>.Type] {
        [
            "TextInput": MetaInfoListTextInputCell.self,
            "Switch": MetaInfoListSwitchCell.self,
            "Display": MetaInfoListDisplayCell.self
        ]
    }
    override var headerIdTypeDict: [String: ListBaseHeader<MetaInfoListSection>.Type] {
        [
            "Header": MetaInfoLIstHeader.self
        ]
    }
    override var data: [MetaInfoListSection] {
        metaInfoListContent
    }
}
