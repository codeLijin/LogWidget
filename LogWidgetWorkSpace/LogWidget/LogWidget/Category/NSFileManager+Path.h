//
//  NSFileManager+Path.h
//  LogWidget
//
//  Created by lijin743 on 2019/9/18.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Path)

#pragma mark - RootPaths
// 获取沙盒数据容器根目录
+ (NSString *)homePath;
// 获取Documents路径
+ (NSString *)documentPath;
// 获取Library路径
+ (NSString *)libraryPath;
// 获取Preferences路径
+ (NSString *)preferencesPath;
// 获取cache路径
+ (NSString *)cachePath;
// 获取tmp路径
+ (NSString *)tmpPath;

@end

NS_ASSUME_NONNULL_END
