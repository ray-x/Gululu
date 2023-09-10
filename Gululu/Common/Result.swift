//
//  Result.swift
//  Gululu
//
//  Created by Ray Xu on 5/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation

public enum Result<T>  {
    case Success(T)
    case Error(Error)
    
    public init(success value: T) {
        self = Result.Success(value)
    }
    
    public init(error: Error) {
        self = Result.Error(error)
    }
    
    public func map<U>(_ f: (T) -> U) -> Result<U> {
        switch self {
        case let .Success(v): return .Success(f(v))
        case let .Error(error): return .Error(error)
        }
    }
    
    public func map<U>(_ f:@escaping (T, ((U)->Void))->Void) -> ((Result<U>)->Void)->Void {
        return { g in
            switch self {
            case let .Success(v): f(v){ transformed in
                g(.Success(transformed))
                }
            case let .Error(error): g(.Error(error))
            }
        }
    }
    
    public func bind<U>(_ f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .Success(v): return f(v)
        case let .Error(error): return .Error(error)
        }
    }
    
    public func bind<U>(_ f: (T) throws -> U) -> Result<U> {
        return bind { t in
            do {
                return .Success(try f(t))
            } catch let error {
                return .Error(error)
            }
        }
    }
    
    public func bind<U>(_ f:@escaping (T, (@escaping(Result<U>)->Void))->Void) -> (@escaping(Result<U>)->Void)->Void {
        return { g in
            switch self {
            case let .Success(v): f(v, g)
            case let .Error(error): g(.Error(error))
            }
        }
    }
    
    
    public func bind<U>(_ f:@escaping (((Result<U>)->Void))->Void) -> ((Result<U>)->Void)->Void {
        return { g in
            switch self {
            case let .Error(error): g(.Error(error))
            default: f(g)
            }
        }
    }
    
    public func ensure<U>(_ f: (Result<T>) -> Result<U>) -> Result<U> {
        return f(self)
    }
    
    public func ensure<U>(_ f:@escaping (Result<T>, ((Result<U>)->Void))->Void) -> ((Result<U>)->Void)->Void {
        return { g in
            f(self, g)
        }
    }
    
    public var value: T? {
        switch self {
        case let .Success(v): return v
        case .Error(_): return nil
        }
    }
    
    
    public var error: Error? {
        switch self {
        case .Success: return nil
        case .Error(let x): return x
        }
    }
    
    
    public func get() throws -> T {
        switch self {
        case let .Success(value): return value
        case .Error(let error): throw error
        }
    }
    public func get() -> Bool {
        switch self {
        case .Success(_): return true
        case .Error(_): return false
        }
    }
    public var boolValue: Bool{
        get{
            switch self {
            case .Success(_): return true
            case .Error(_): return false
            }
        }
    }
    
    public var rawValue: Bool {
        switch self {
        case .Success(_): return true
        case .Error(_): return false
        }
    }
}
