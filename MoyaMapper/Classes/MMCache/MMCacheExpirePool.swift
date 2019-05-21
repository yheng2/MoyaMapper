//
//  MMCacheExpirePool.swift
//  MoyaMapper_Example
//
//  Created by Yiwei Heng on 2019/5/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class MMCacheExpirePool {
    static let shared = MMCacheExpirePool()
    
    /// pool: control the lifecycle of cached data
    ///
    /// key: cacheKey
    /// value: expiring timestamp
    var pool = [String: String]()
   
    
    func checkAlreadyExpired(_ target: Target, cacheType: MMCache.CacheKeyType = .default) -> Bool {
        return true
    }
    
    
    
}
