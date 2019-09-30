//
//  LogWidgetFile.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LogWidget/PublicEnum.h>

#define YNLogFileManager [LogWidgetFileManager fileManager]

NS_ASSUME_NONNULL_BEGIN

@interface LogWidgetFileManager : NSObject

+ (nullable instancetype)fileManager;
- (instancetype)init __attribute__((unavailable("use +(instancetype)fileManager")));
+ (instancetype)new __attribute__((unavailable("use +(instancetype)fileManager")));

#pragma mark - PUBLIC METHOD
/**
 获取文件/文件夹完整路径
 
 @param path 父级目录
 @param relativePath 相对路径
 @return full_path
 */
- (NSString *)getFullPathBy:(DOCUMENT_PATH)path relativePath:(nullable NSString *)relativePath;

/**
 判断文件/文件夹是否存在
 
 @param path 文件/文件夹 完整路径 getFullPathBy:relativePath
 @param isDirectory 是否为文件夹, 出参
 @return 文件/文件夹是否存在
 */
- (BOOL)fileExistsAtPath:(nonnull NSString *)path
             isDirectory:(nullable out BOOL *)isDirectory;

/**
 获取文件/文件夹属性
 @param path 文件/文件夹 完整路径 getFullPathBy:relativePath
 */
- (nullable NSDictionary<NSFileAttributeKey, id> *)attributesOfItemAtPath:(nonnull NSString *)path;

/**
 获取文件/文件夹 size

 @param path 文件/文件夹 完整路径 getFullPathBy:relativePath
 @param standard 计量单位
 @return 文件大小: 根据计量单位区分取值
 */
- (NSNumber *)getSourceSize:(NSString *)path sizeStandard:(SIZE_STANDARD)standard;

/**
 获取文件/文件夹 时间属性
 
 @param type 时间类型
 @param path 完整路径
 @param dateFormat 时间格式
 @return 时间 / nil | string | date
 */
- (nullable id)getSourceTimeType:(FILE_TIME_ATTRIBUTE_TYPE)type
                        fullPath:(nonnull NSString *)path
                      dateFormat:(nullable NSString *)dateFormat;

/**
 删除文件夹
 
 @param path 文件夹路径
 @param error 错误信息
 @return 删除成功
 */
- (BOOL)removeItemAtPath:(NSString *_Nonnull)path
                   error:(NSError *__autoreleasing *_Nullable)error;

/**
 移动文件(夹)
 
 @param sourceFullPath 源完全路径
 @param toPath 目标主目录
 @param toRelativePath 目标相对路径
 @param overwrite 是否覆盖
 @param error 错误信息
 @return 操作结果
 */
- (BOOL)moveItemAtPath:(NSString *)sourceFullPath
                toPath:(DOCUMENT_PATH)toPath
          toRelativePath:(nullable NSString *)toRelativePath
             overwrite:(BOOL)overwrite
                 error:(NSError *__autoreleasing *)error;

- (BOOL)moveItemAtPath:(NSString *)sourceFullPath
              fullPath:(nullable NSString *)fullPath
             overwrite:(BOOL)overwrite
                 error:(NSError *__autoreleasing *)error;

/**
 复制文件(夹)
 
 @param sourceFullPath 源完全路径
 @param toPath 目标主目录
 @param toRelativePath 目标相对路径
 @param overwrite 是否覆盖
 @param error 错误信息
 */
- (BOOL)yn_copyItemAtPath:(NSString *)sourceFullPath
                   toPath:(DOCUMENT_PATH)toPath
           toRelativePath:(nullable NSString *)toRelativePath
                overwrite:(BOOL)overwrite
                    error:(NSError *__autoreleasing *)error;

- (BOOL)yn_copyItemAtPath:(NSString *)sourceFullPath
                 fullPath:(nullable NSString *)fullPath
                overwrite:(BOOL)overwrite
                    error:(NSError *__autoreleasing *)error;
#pragma mark - getter
/**
 文件管理器
 */
- (nonnull NSFileManager *)fileManager;

/**
 读写文件队列
 */
- (dispatch_queue_t)fileReadWriteQueue;

/**
 文件操作队列
 */
- (dispatch_queue_t)fileOperationQueue;
@end

NS_ASSUME_NONNULL_END
