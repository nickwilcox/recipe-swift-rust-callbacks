private class WrapClosure<T> {
    fileprivate let closure: T
    init(closure: T) {
        self.closure = closure
    }
}
public func FriendlyAsyncOperation(closure: @escaping (Bool) -> Void) {
    let wrappedClosure = WrapClosure(closure: closure)
    let userdata = Unmanaged.passRetained(wrappedClosure).toOpaque()
    let callback: @convention(c) (UnsafeMutableRawPointer, Bool) -> Void = { (_ userdata: UnsafeMutableRawPointer, _ success: Bool) in
        let wrappedClosure: WrapClosure<(Bool) -> Void> = Unmanaged.fromOpaque(userdata).takeRetainedValue()
        wrappedClosure.closure(success)
    }
    let completion = CompletedCallback(userdata: userdata, callback: callback)
    async_operation(completion)
}