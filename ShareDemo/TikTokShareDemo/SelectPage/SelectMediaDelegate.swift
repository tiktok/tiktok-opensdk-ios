/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import TikTokOpenSDKCore
import TikTokOpenShareSDK

class SelectMediaDelegate: NSObject, QBImagePickerControllerDelegate {

    weak var viewController: SelectMediaViewController?

    func selectMedia(_ selectMediaVC: SelectMediaViewController, mediaType: QBImagePickerMediaType) {
        viewController = selectMediaVC
        let picker = QBImagePickerController()
        picker.delegate = self
        picker.mediaType = mediaType
        picker.maximumNumberOfSelection = 35
        picker.allowsMultipleSelection = true
        picker.showsNumberOfSelectedAssets = true
        selectMediaVC.present(picker, animated: true)
    }

    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        let mediaType = imagePickerController.mediaType
        imagePickerController.dismiss(animated: true) {
            guard let navCon = self.viewController?.navigationController else {
                return
            }
            let assets: [String] = assets.reduce(into: [String]()) { ret, ele in
                guard let ele = ele as? PHAsset else {
                    return
                }
                ret.append(ele.localIdentifier)
            }
            let viewController = MetaInfoViewController(withMediaType: mediaType, assets: assets, customClientKey: self.viewController?.customClientKey)
            navCon.pushViewController(viewController, animated: true)
        }
    }

    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        imagePickerController.dismiss(animated: true)
    }

}
