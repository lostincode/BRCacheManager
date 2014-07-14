# BRCacheManager

[![CI Status](http://img.shields.io/travis/lostincode/BRCacheManager.svg?style=flat)](https://travis-ci.org/lostincode/BRCacheManager)
[![Version](https://img.shields.io/cocoapods/v/BRCacheManager.svg?style=flat)](http://cocoadocs.org/docsets/BRCacheManager)
[![License](https://img.shields.io/cocoapods/l/BRCacheManager.svg?style=flat)](http://cocoadocs.org/docsets/BRCacheManager)
[![Platform](https://img.shields.io/cocoapods/p/BRCacheManager.svg?style=flat)](http://cocoadocs.org/docsets/BRCacheManager)

A simple disk based cache for you models. Typically you might fetch some content via AFNetwroking, convert JSON to your custom model and display it. Speed up your app by using BRCacheManager to cache your content for x amount of seconds.

## Usage

(coming soon)
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Example

Example of workflow with AFNetworking.

```objective-c
#import <BRCacheManager.h>

+ (void)getMyContent
      completionHandler:(CustomBlock)completionHandler
{
    NSString *path = @"myendpoint";
    
    //check if we have content in the cache with a max age of 5 minutes
    id contents = [BRCacheManager getCachedContentForKey:path withExpireTimeInSeconds:(60 * 5)];

    if (contents) {
        return completionHandler(contents, nil);
    }
    
    [[CustomSessionManager sharedClient] GET:path
                                         parameters:nil
                                            success:^(NSURLSessionDataTask *task, id responseObject)
     {
 
         MyModel *myModel = [self customModelFromJson:responseObject];
         
         //save your content to disk
         [BRCacheManager saveCachedContent:[myModel copy] forKey:path];
         
         return completionHandler(myModel, nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         return completionHandler(nil, error);
     }];
}

```

## Requirements

iOS 7 + ARC. If you're caching a custom model, it must implement NSCoding.

## Installation

BRCacheManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "BRCacheManager"

## License

BRCacheManager is available under the MIT license. See the LICENSE file for more info.

