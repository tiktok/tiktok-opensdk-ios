/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@propertyWrapper
public struct Observable<Value: Equatable> {

    class Wrapper {
        var observers: [Observer<Value?>] = []
        var value: Value? {
            didSet {
                observers.forEach { $0.invoke(value) }
            }
        }
    }

    let wrapper = Wrapper()

    public var wrappedValue: Value {
        set {
            wrapper.value = newValue
        }
        get {
            return wrapper.value!
        }
    }

    public var projectedValue: Self { self }

    public init(wrappedValue val: Value) {
        wrapper.value = val
    }

    public init() {
        wrapper.value = nil
    }

    public func addObserver(_ obs: Observer<Value?>) {
        wrapper.observers.append(obs)
    }

    public func addObserver(callBack: @escaping((Value?) -> Void)) {
        let obs = Observer<Value?>()
        obs.addAction(callBack)
        addObserver(obs)
    }

}

// Observable -> Observer
public class Observer<Value> {
    typealias Action = (Value) -> Void
    private var actions: [Action] = []

    func invoke(_ val: Value) {
        actions.forEach { $0(val) }
    }

    func addAction(_ action: @escaping(Action)) {
        actions.append(action)
    }
}

public class Binder<Value: Equatable>: Observer<Value?> {

    public var recieveChange: ((Value?) -> Void)?

    public func pushChange(_ val: Value) {
        valueWrapper?.value = val
    }

    private var valueWrapper: Observable<Value>.Wrapper?

    public func bind(with obs: Observable<Value>) {
        valueWrapper = obs.wrapper
        if let val = obs.wrapper.value {
            recieveChange?(val)
        }
        addAction {[weak self] newVal in
            guard let self = self else {
                return
            }
            self.recieveChange?(newVal)
        }
        obs.addObserver(self)
    }
}
