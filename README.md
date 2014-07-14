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

+ (void)getMyContent
      completionHandler:(CustomBlock)completionHandler
{
    NSString *path = @"myendpoint";
    
    //cache for 5 minutes
    id contents = [BRCacheManager getCachedContentForKey:path withExpireTimeInSeconds:(60 * 5)];

    if (contents) {
        return completionHandler(contents, nil);
    }
    
    [[CustomSessionManager sharedClient] GET:path
                                         parameters:nil
                                            success:^(NSURLSessionDataTask *task, id responseObject)
     {
 
         MyModel *myModel = [self customModelFromJson:responseObject];
         
         [BRCacheManager saveCachedContent:[myModel copy] forKey:path];
         
         return completionHandler(myModel, nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         return completionHandler(nil, error);
     }];
}

```

## Requirements

## Installation

BRCacheManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "BRCacheManager"

## Author

Bill, roundedvision@gmail.com

## License

BRCacheManager is available under the MIT license. See the LICENSE file for more info.

