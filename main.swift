class TestLifetime {
    let sema: DispatchSemaphore
    init(_ sema: DispatchSemaphore) {
        self.sema = sema
        print("start of test lifetime")
    }

    deinit {
        print("end of test lifetime")
    }

    func completed(_ success: Bool) {
        print("the async operation has completed with result \(success)")
        sema.signal()
    }
}

func startOperation(_ sema: DispatchSemaphore) {
    let test = TestLifetime(sema) 
    print("starting async operation")
    FriendlyAsyncOperation() { [test] success in
        test.completed(success)
    }
}

let semaphore = DispatchSemaphore(value: 0)
startOperation(semaphore)
semaphore.wait()