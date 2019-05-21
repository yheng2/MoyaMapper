//
//  MoyaProviderType+Cache.swift
//  MoyaMapper
//
//  Created by 林洵锋 on 2018/10/27.
//

import Moya
import Result

internal class SimpleCancellableClass: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}

public extension MoyaProviderType {
    /**
     缓存网络请求:
     
     - 如果本地无缓存，直接返回网络请求到的数据
     - 如果本地有缓存，先返回缓存，再返回网络请求到的数据
     - 只会缓存请求成功的数据（缓存的数据 response 的状态码为 MMStatusCode.cache）
     - 适用于APP首页数据缓存
     
     */
    
    func cacheRequest(
        _ target: Target,
        alwaysFetchCache: Bool = false,
        cacheType: MMCache.CacheKeyType = .default,
        callbackQueue: DispatchQueue? = nil,
        progress: Moya.ProgressBlock? = nil,
        expireInSec: Int = 0,
        completion: @escaping Moya.Completion
    ) -> Cancellable {
        print("111")
        let cache = MMCache.shared.fetchResponseCache(target: target, cacheKey: cacheType)
        
        if alwaysFetchCache && cache != nil {
            completion(Result(value: cache!))
        } else {
            if MMCache.shared.isNoRecord(target, cacheType: cacheType) {
                MMCache.shared.record(target, cacheType: cacheType)
                if cache != nil {
                    completion(Result(value: cache!))
                }
            }
        }
        print("222")
        let poolManager = MMCacheExpirePool.shared
        print("333")
//        if poolManager.checkAlreadyExpired(target, cacheType: cacheType) || cache == nil {
        
            return self.request(target, callbackQueue: callbackQueue, progress: progress) { result in
                if let resp = try? result.value?.filterSuccessfulStatusCodes(),
                    resp != nil { // 更新缓存
                    MMCache.shared.cacheResponse(resp!, target: target, cacheKey: cacheType)
//                    poolManager.updateExpireTimeStamp(target, cacheType: cacheType, expireInSec: expireInSec)
                }
                completion(result)
            }
//        } else {
//            return SimpleCancellableClass()
//        }
    }
}
