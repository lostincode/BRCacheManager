//
//  CacheManager.h
//  BRCacheManager
//
//  Created by Bill Richards on 7/11/14.
//  Copyright (c) 2014 Bill Richards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRCacheManager : NSObject

+ (NSString *)getCachePath;
+ (id)getCachedContentForKey:(NSString *)cacheTitle;
+ (id)getCachedContentForKey:(NSString *)key withExpireTimeInSeconds:(NSUInteger)expireTime;
+ (void)saveCachedContent:(id)content forKey:(NSString *)key;

@end
