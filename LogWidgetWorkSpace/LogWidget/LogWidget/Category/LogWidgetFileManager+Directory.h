//
//  LogWidgetFileManager+Directory.h
//  LogWidget
//
//  Created by lijin743 on 2019/9/18.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <LogWidget/LogWidget.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogWidgetFileManager (Directory)

/**
 创建文件夹
 
 @param folder 文件夹路径
 @param path 文件夹所在根目录
 @param clearIfNeeded 如果已存在, 是否重新创建
 @return 操作是否成功
 */
- (BOOL)createFolder:(nonnull NSString *)folder
              inPath:(DOCUMENT_PATH)path
       clearIfNeeded:(clearDir)clearIfNeeded;

/**
 计算文件夹大小

 @param path 文件夹路径
 @param standard 计量单位
 @return 文件夹size: 根据计量单位取值 unsign long long | float | double
 */
- (NSNumber *)getDirSize:(NSString *)path sizeStandard:(SIZE_STANDARD)standard;

#pragma mark - Private Method
/**
 创建文件夹
 
 @param path 文件夹路径
 @param intermediateDirectories 是否创建中间文件夹
 @param error 错误信息
 @return 是否创建成功
 */
- (BOOL)fileManager:(NSFileManager *_Nonnull)fileManager
       createFolder:(NSString *_Nonnull)path
intermediateDirectories:(BOOL)intermediateDirectories
              error:(NSError *__autoreleasing *_Nullable)error ;

/**
 删除文件夹
 
 @param path 文件夹路径
 @param error 错误信息
 @return 删除成功
 */
- (BOOL)fileManager:(NSFileManager *_Nonnull)fileManager
   removeItemAtPath:(NSString *_Nonnull)path
              error:(NSError *__autoreleasing *_Nullable)error;
@end

NS_ASSUME_NONNULL_END
