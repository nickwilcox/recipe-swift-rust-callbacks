#![crate_type = "staticlib"]
#![allow(dead_code)]

use std::thread;
use std::time::Duration;
use std::ffi::c_void;

#[repr(C)]
pub struct CompletedCallback {
    userdata: *mut c_void,
    callback: extern "C" fn(*mut c_void, bool),
}

unsafe impl Send for CompletedCallback {}

impl CompletedCallback {
    fn succeeded(self) {
        (self.callback)(self.userdata, true);
        std::mem::forget(self)
    }
    fn failed(self) {
        (self.callback)(self.userdata, false);
        std::mem::forget(self)
    }
}

impl Drop for CompletedCallback {
    fn drop(&mut self) {
        panic!("CompletedCallback must have explicit succeeded or failed call")
    }
}

#[no_mangle]
pub extern "C" fn async_operation(callback: CompletedCallback) {
    thread::spawn(move || {
        thread::sleep(Duration::from_secs(3));
        callback.succeeded()
    });
}