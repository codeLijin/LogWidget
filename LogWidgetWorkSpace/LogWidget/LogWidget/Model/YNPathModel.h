//
//  YNPathModel.h
//  LogWidget
//
//  Created by lijin743 on 2019/9/28.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <LogWidget/LogWidget.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNPathModel : YNCodingModel
#pragma mark - Normal Properties
/**
 完整
 */
@property (nonatomic, readwrite, copy) NSString *oringinPath;
/**
 是否为文件夹
 */
@property (nonatomic, readonly, assign, getter=isDirectory) BOOL directory;
/**
 文件(夹) 最后一个路径
 */
@property (nonatomic, readwrite, copy) NSString *lastPathComponent;
/**
 相对路径, exp: ~/Document/xxx/xx/x
 */
@property (nonatomic, readonly, copy) NSString *relativePath;
/**
 文件后缀
 */
@property (nonatomic, readwrite, copy) NSString *pathExtension;
/**
 去除后缀名的路径
 */
@property (nonatomic, readonly, copy) NSString *stringByDeletingPathExtension;
#pragma mark - YNFile Propertise
/**
 桥接属性, 主目录
 */
@property (nonatomic, readwrite, assign) DOCUMENT_PATH yn_PATH;
/**
 相对路径
 */
@property (nonatomic, readwrite, copy) NSString *yn_relativePath;
/**
 文件名
 */
@property (nonatomic, readwrite, copy) NSString *yn_fileName;


+ (instancetype)modelWithOringinPath:(NSString *)oringinPath isDirectory:(BOOL)isDirectory;

+ (instancetype)modelWithYNPath:(DOCUMENT_PATH)yn_PATH
                yn_relativePath:(nullable NSString *)yn_relativePath
                    yn_fileName:(nullable NSString *)yn_fileName
                    isDirectory:(BOOL)isDirectory;

#pragma mark - options
- (BOOL)createClearIfNeeded:(BOOL)destroyIfNeeded;

- (void)yn_write:(nonnull NSObject *)content overwrite:(BOOL)overwrite completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion;

- (void)yn_moveToYN_Path:(DOCUMENT_PATH)yn_PATH
          toRelativePath:(NSString *)yn_relativePath
               overwrite:(BOOL)overwrite
              completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion;

- (void)yn_moveToFullPath:(NSString *)fullPath overwrite:(BOOL)overwrite completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion;
@end

NS_ASSUME_NONNULL_END
