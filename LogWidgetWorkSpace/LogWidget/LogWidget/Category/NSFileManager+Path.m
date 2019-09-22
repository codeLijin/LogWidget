//
//  NSFileManager+Path.m
//  LogWidget
//
//  Created by lijin743 on 2019/9/18.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "NSFileManager+Path.h"

@implementation NSFileManager (Path)

#pragma mark - RootPaths
// 获取沙盒数据容器根目录
+ (NSString *)homePath {
    NSString *homePath = NSHomeDirectory();
//    NSLog(@"home根目录:%@", homePath);
    return homePath;
}

// 获取Documents路径
+ (NSString *)documentPath {
    /*参数一：指定要搜索的文件夹枚举值
     参数二：指定搜索的域Domian: NSUserDomainMask
     参数三：是否需要绝对/全路径：NO：波浪线~标识数据容器的根目录; YES(一般制定): 全路径
     */
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSLog(@"documens路径:%@", documentPath);
    return documentPath;
}

// 获取Library路径
+ (NSString *)libraryPath {
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"libaray路径:%@", libraryPath);
    return libraryPath;
}

// 获取Preferences路径
+ (NSString *)preferencesPath {
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    return [libraryDir stringByAppendingPathComponent:@"Preferences"];
}

// 获取cache路径
+ (NSString *)cachePath {
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachesPaths objectAtIndex:0];
//    NSLog(@"caches路径:%@ \n ",cachePath);
    return cachePath;
}

// 获取tmp路径
+ (NSString *)tmpPath {
    NSString *tmpPath = NSTemporaryDirectory();
//    NSLog(@"tmp路径：%@", tmpPath);
    return tmpPath;
}

@end
