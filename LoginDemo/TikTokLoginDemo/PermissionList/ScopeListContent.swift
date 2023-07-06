/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

typealias ScopeListPropagateChange = (Any?, ScopeListViewModel, ScopeListItem) -> Void

let propagateBool = { (keyPath: ReferenceWritableKeyPath<ScopeListViewModel, Bool>) -> ScopeListPropagateChange in
    return { (change: Any?, vm: ScopeListViewModel, _: ScopeListItem) -> Void in
        guard let change = change as? Bool else {
            return
        }
        vm[keyPath: keyPath] = change
    }
}

let propagateScope = { (change: Any?, vm: ScopeListViewModel, item: ScopeListItem) -> Void in
    guard let change = change as? Bool, let title = item.title else {
        return
    }
    if change {
        vm.scopes.insert(title)
    } else {
        vm.scopes.remove(title)
    }
}

let setDefaultScope = { (vm: ScopeListViewModel, item: inout ScopeListItem) -> Void in
    if item.isRequired {
        item.default = true
        vm.scopes.insert(item.title!)
    } else {
        item.default = vm.scopes.contains(item.title!)
    }
}

let ScopeListContent: [ScopeListSection] = [
    ScopeListSection(headerTitle: "Config", hideImg: false, items: [
        ScopeListItem(
            title: "Always in Web",
            subtitle: "Always authorize via web",
            type: .switch,
            isRequired: false,
            setDefault: { $1.default = $0.alwaysInWeb },
            propagateChange: propagateBool(\.alwaysInWeb),
            default: false
        )
    ]),
    ScopeListSection(headerTitle: "Permissions", hideImg: true, items: [
        ScopeListItem(
            title: "user.info.basic",
            subtitle: "Read a user's profile info (open id, avatar, display name). This scope is required.",
            type: .switch,
            isRequired: true,
            setDefault: setDefaultScope,
            propagateChange: propagateScope,
            default: true
        ),
        ScopeListItem(
            title: "user.info.profile",
            subtitle: "Read access to profile_web_link, profile_deep_link, bio_description, is_verified.",
            type: .switch,
            isRequired: true,
            setDefault: setDefaultScope,
            propagateChange: propagateScope,
            default: false
        ),
        ScopeListItem(
            title: "user.info.stats",
            subtitle: "Read access to a user's statistical data, such as likes count, follower count, following count, and video count.",
            type: .switch,
            isRequired: true,
            setDefault: setDefaultScope,
            propagateChange: propagateScope,
            default: false
        ),
        ScopeListItem(
            title: "video.upload",
            subtitle: "Share videos as a draft to your TikTok account",
            type: .switch,
            isRequired: false,
            setDefault: setDefaultScope,
            propagateChange: propagateScope,
            default: false
        ),
        ScopeListItem(
            title: "video.list",
            subtitle: "Read your public videos on TikTok",
            type: .switch,
            isRequired: false,
            setDefault: setDefaultScope,
            propagateChange: propagateScope,
            default: false
        )
    ])
]
