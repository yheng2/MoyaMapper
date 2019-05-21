//
//  MMCacheExpirePool.swift
//  MoyaMapper_Example
//
//  Created by Yiwei Heng on 2019/5/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Moya
#if !COCOAPODS
import MoyaMapper
#endif

class MMCacheExpirePool {
    static let shared = MMCacheExpirePool()
    
    /// pool: control the lifecycle of cached data
    ///
    /// key: cacheKey
    /// value: expiring timestamp
    var pool = [String: String]()
   
    var timeStamp: Int {
        get {
            return Int((Date().timeIntervalSince1970 * 1000.0).rounded())
        }
    }
    
    func checkAlreadyExpired(_ target: TargetType, cacheType: MMCache.CacheKeyType = .default) -> Bool {
        if let expireTimeStamp = pool[target.fetchCacheKey(cacheType)] {
            return timeStamp >= (Int(expireTimeStamp) ?? 0)
        } else {
            return false
        }
    }
    
    func updateExpireTimeStamp(_ target: TargetType, cacheType: MMCache.CacheKeyType = .default, expireInSec: Int = 0) {
        /// Save key and value(timestamp) into pool
        pool[target.fetchCacheKey(cacheType)] = "\(timeStamp + expireInSec * 1000)"
    }
}
