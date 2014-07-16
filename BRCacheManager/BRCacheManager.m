//
//  CacheManager.m
//  BRCacheManager
//
//  Created by Bill Richards on 7/11/14.
//  Copyright (c) 2014 Bill Richards. All rights reserved.
//

#import "BRCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface BRCacheManager()
@property (strong, nonatomic) dispatch_queue_t fileQueue;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (copy, nonatomic) NSString *diskCachePath;
@end

@implementation BRCacheManager

+ (BRCacheManager *)sharedManager
{
    static dispatch_once_t pred;
    static BRCacheManager *shared;
    dispatch_once(&pred, ^{
        shared = [[BRCacheManager alloc] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.fileQueue = dispatch_queue_create("com.wrichards.BRCacheManager", DISPATCH_QUEUE_SERIAL);
    self.diskCachePath = [self getCachePath];
    
    dispatch_sync(self.fileQueue, ^{
        self.fileManager = [NSFileManager new];
    });
}

- (NSString *)getCachePath
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cacheFolder   = NSStringFromClass([self class]);
    NSString *cacheDirPath  = [documentsPath stringByAppendingPathComponent:cacheFolder];
    
    return cacheDirPath;
}

- (NSString *)getCacheFilePathForKey:(NSString *)key
{
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [self md5HexDigest:key]];
    NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

- (id)getCachedContentForKey:(NSString *)key
{
    return [self getCachedContentForKey:key withExpireTimeInSeconds:3600];
}

- (id)getCachedContentForKey:(NSString *)key withExpireTimeInSeconds:(NSUInteger)expireTime
{
    __block id content = nil;
    
    __weak BRCacheManager *weakSelf = self;
    
    dispatch_sync(self.fileQueue, ^{
        
        BRCacheManager *strongSelf = weakSelf;
        
        if (!strongSelf) {
            return;
        }
        
        NSString *filePath = [strongSelf getCacheFilePathForKey:key];
        
        BOOL fileExists = [strongSelf.fileManager fileExistsAtPath:filePath];
        
        if (!fileExists) {
            return;
        }
        
        NSDictionary *attributes = [strongSelf.fileManager attributesOfItemAtPath:filePath error:nil];
        NSDate *modificationDate = attributes[NSFileModificationDate];
        
        NSDate *today = [NSDate date];
        
        if ([today timeIntervalSinceDate:modificationDate] > expireTime) {
            return;
        }
        
        content = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if (!content) {
            return;
        }
        
    });
    
    return content;
}

- (void)saveCachedContent:(id)content forKey:(NSString *)key
{
    __weak BRCacheManager *weakSelf = self;
    
    dispatch_async(self.fileQueue, ^{
        
        BRCacheManager *strongSelf = weakSelf;
        
        if (!strongSelf) {
            return;
        }
        
        if (![strongSelf.fileManager fileExistsAtPath:strongSelf.diskCachePath]) {
            [strongSelf.fileManager createDirectoryAtPath:strongSelf.diskCachePath
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
        }
        
        NSString *filePath = [strongSelf getCacheFilePathForKey:key];
        [NSKeyedArchiver archiveRootObject:content toFile:filePath];
        
    });
}

- (void)removeCachedContentForKey:(NSString *)key
{
    __weak BRCacheManager *weakSelf = self;
    
    dispatch_async(self.fileQueue, ^{
        
        BRCacheManager *strongSelf = weakSelf;
        
        if (!strongSelf) {
            return;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [strongSelf getCacheFilePathForKey:key];
        
        [fileManager removeItemAtPath:filePath error:nil];
        
    });
}

/**
 * md5HexDigest
 * Credit: http://stackoverflow.com/a/3104362
 */

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

+ (void)clearCaches
{
    NSString *file;
    NSString *path = [self getCachePath];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while (file = [enumerator nextObject]) {
        
        BOOL isDirectory = NO;
        NSString *currentItemPath = [NSString stringWithFormat:@"%@/%@",path,file];
        [[NSFileManager defaultManager] fileExistsAtPath: currentItemPath
                                             isDirectory: &isDirectory];
        if (!isDirectory) {
            NSError *er = nil;
            [[NSFileManager defaultManager] removeItemAtPath:currentItemPath error:&er];
        }
    }
}

@end
