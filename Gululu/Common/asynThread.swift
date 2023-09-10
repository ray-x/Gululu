//
//  asynThread.swift
//  Gululu
//
//  Created by Ray Xu on 12/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//


import Foundation

/**
 Several functions that should make multithreading simpler.
 Use this functions together with Signal.ensure:
 Signal.ensure(Thread.main) // will create a new Signal on the main queue
 */
public final class Thread {

    /// Transform a signal to the main queue
    public static func main<T>(_ a: Result<T>, completion: @escaping (Result<T>)->Void) {
        queue(DispatchQueue.main)(a, completion)
    }
    /// Transform the signal to a specified queue
    public static func queue<T>(_ queue: DispatchQueue) -> (Result<T>, @escaping (Result<T>)->Void) -> Void {
        return { a, completion in
            queue.async{
                completion(a)
            }
        }
    }
    /// Transform the signal to a global background queue with priority default
    public static func background<T>(_ a: Result<T>, completion: @escaping (Result<T>)->Void) {
        DispatchQueue.global(qos: .default).async {
             completion(a)
        }
    }
}
