//
//  Observer.swift
//  GululuReactive
//
//  Created by Ray Xu on 2/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation

public final class Signal<T> {
    
    fileprivate var value: Result<T>?
    fileprivate var callbacks: [(Result<T>) -> Void] = []
    fileprivate let mutex = Mutex()
    
    /// Automatically infer the type of the signal from the argument.
    public convenience init(_ value: T){
        self.init()
        self.value = .Success(value)
    }
    
    public init() {
    }
    
    
    public func map<U>(_ f: @escaping (T) -> U) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            signal.update(result.map(f))
        }
        return signal
    }
    
    public func bind<U>(_ f: @escaping (T) -> Result<U>) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            signal.update(result.bind(f))
        }
        return signal
    }
    

    public func bind<U>(_ f: @escaping (T) throws -> U) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            signal.update(result.bind(f))
        }
        return signal
    }

    public func bind<U>(_ f: @escaping (T, @escaping((Result<U>)->Void))->Void) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            result.bind(f)(signal.update)
        }
        return signal
    }
    
    
    public func bind<U>(_ f: @escaping (((Result<U>)->Void))->Void) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            result.bind(f)(signal.update)
        }
        return signal
    }
    
    
    public func bind<U>(_ f: @escaping ((T) -> Signal<U>)) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            switch(result) {
            case let .Success(value):
                let innerSignal = f(value)
                let _ =  innerSignal.subscribe { innerResult in
                    signal.update(innerResult)
                }
            case let .Error(error):
                signal.update(.Error(error))
            }
        }
        return signal
    }
    
    public func ensure<U>(_ f: @escaping (Result<T>, ((Result<U>)->Void))->Void) -> Signal<U> {
        let signal = Signal<U>()
        let _ = subscribe { result in
            f(result) { signal.update($0) }
        }
        return signal
    }
    

    public func subscribe(_ f: @escaping (Result<T>) -> Void) -> Signal<T> {
        if let value = value {
            f(value)
        }
        mutex.lock {
            callbacks.append(f)
        }
        return self
    }
    
    

    public func onSuccess(_ g: @escaping (T) -> Void) -> Signal<T> {
        let _ = subscribe { result in
            switch(result) {
            case let .Success(value): g(value)
            case .Error(_): return
            }
        }
        return self
    }
    

    public func onError(_ g: @escaping (Error) -> Void) -> Signal<T> {
        let _ = subscribe { result in
            switch(result) {
            case .Success(_): return
            case let .Error(error): g(error)
            }
        }
        return self
    }
   

    public func update(_ result: Result<T>) {
        mutex.lock {
            value = result
            callbacks.forEach{$0(result)}
        }
    }
    

    public func update(_ value: T) {
        update(.Success(value))
    }
    

    public func update(_ error: Error) {
        update(.Error(error))
    }
    

    public func peek() -> T? {
        return value?.value
    }
}


private class Mutex {
    fileprivate var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    func lock() -> Int32 {
        return pthread_mutex_lock(&mutex)
    }
    
    func unlock() -> Int32 {
        return pthread_mutex_unlock(&mutex)
    }
    
    func lock(_ closure: () -> Void) {
        let status = lock()
        assert(status == 0, "pthread_mutex_lock: \(strerror(status))")
        defer { unlock() }
        closure()
    }
}

