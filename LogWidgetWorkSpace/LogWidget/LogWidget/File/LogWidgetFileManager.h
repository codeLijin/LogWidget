//
//  LogWidgetFile.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LogWidget/PublicEnum.h>

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
- (NSString *)getFullPathBy:(DOCUMENT_PATH)path relativePath:(nonnull NSString *)relativePath;

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

#pragma mark - getter
/**
 文件管理器
 */
- (nonnull NSFileManager *)fileManager;
@end

NS_ASSUME_NONNULL_END
