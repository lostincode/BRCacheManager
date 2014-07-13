//
//  CacheManager.m
//  BRCacheManager
//
//  Created by Bill Richards on 7/11/14.
//  Copyright (c) 2014 Bill Richards. All rights reserved.
//

#import "BRCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BRCacheManager

+ (NSString *)getCachePath
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cacheDirPath = [documentsPath stringByAppendingPathComponent:@"cache"];
    return cacheDirPath;
}

+ (id)getCachedContentForKey:(NSString *)key
{
    [self [getCachedContentForKey withExpireTimeInSeconds:3600];
}

+ (id)getCachedContentForKey:(NSString *)key withExpireTimeInSeconds:(NSUInteger)expireTime
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDirPath = [self getCachePath];
    
    if (![fileManager fileExistsAtPath:cacheDirPath]) {
        [fileManager createDirectoryAtPath:cacheDirPath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
 
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [self md5HexDigest:key]];
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    
    if (!fileExists) {
        return nil;
    }
    
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSDate *modificationDate = attributes[NSFileModificationDate];
    
    NSDate *today = [NSDate date];
    if ([today timeIntervalSinceDate:modificationDate] > expireTime) {
        return nil;
    }
    
    id content = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (!content) {
        return nil;
    }
    
    return content;
}

+ (void)saveCachedContent:(id)content forKey:(NSString *)key
{
    NSString *cacheDirPath = [self getCachePath];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [self md5HexDigest:key]];
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:content toFile:filePath];
}

+ (NSString *)md5HexDigest:(NSString *)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

@end
