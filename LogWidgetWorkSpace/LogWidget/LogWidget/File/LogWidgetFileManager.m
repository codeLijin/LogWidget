//
//  LogWidgetFile.m
//  LogWidget
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "LogWidgetFileManager.h"

@interface LogWidgetFileManager () {
    
}

@property (nonatomic, readwrite, strong) NSFileManager *fileManager;
@end

@implementation LogWidgetFileManager

+ (nullable instancetype)fileManager {
    static LogWidgetFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.fileManager = [NSFileManager defaultManager];
    });
    return manager;
}

/**
 获取文件/文件夹完整路径
 
 @param path 父级目录
 @param relativePath 相对路径
 @return full_path
 */
- (NSString *)getFullPathBy:(DOCUMENT_PATH)path relativePath:(nonnull NSString *)relativePath {
    NSString *pre_path = nil;
    switch (path) {
        case DOCUMENT_PATH_HOME:
            pre_path = [NSFileManager homePath];
            break;
        case DOCUMENT_PATH_DOCUMENT:
            pre_path = [NSFileManager documentPath];
            break;
        case DOCUMENT_PATH_LIBARAY:
            pre_path = [NSFileManager libraryPath];
            break;
        case DOCUMENT_PATH_PREFERENCES:
            pre_path = [NSFileManager preferencesPath];
            break;
        case DOCUMENT_PATH_CACHE:
            pre_path = [NSFileManager cachePath];
            break;
        case DOCUMENT_PATH_TMP:
            pre_path = [NSFileManager tmpPath];
            break;
        default:
            // TODO: get Path Error, Make AlertView Show On
            break;
    }
    if (!pre_path) {
        return pre_path;
    }
    pre_path = [pre_path stringByAppendingPathComponent:relativePath];
    return pre_path;
}

/**
 判断文件/文件夹是否存在
 
 @param path 文件/文件夹 路径
 @param isDirectory 是否为文件夹
 @return 文件/文件夹是否存在
 */
- (BOOL)fileExistsAtPath:(nonnull NSString *)path isDirectory:(nullable out BOOL *)isDirectory {
    BOOL exists = [self.fileManager fileExistsAtPath:path isDirectory:isDirectory];
    return exists;
}

/**
 获取文件/文件夹属性
 @param path 文件/文件夹 完整路径 getFullPathBy:relativePath
 */
- (nullable NSDictionary<NSFileAttributeKey, id> *)attributesOfItemAtPath:(nonnull NSString *)path {
    NSError *error;
    NSDictionary<NSFileAttributeKey, id> *fileInfo = [self.fileManager attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%s -- [%d] %@", __FUNCTION__, __LINE__, error);
        return nil;
    }
    return fileInfo;
}

/**
 获取文件/文件夹 size
 
 @param path 文件/文件夹 完整路径 getFullPathBy:relativePath
 @param standard 计量单位
 @return 文件大小: 根据计量单位区分取值
 */
- (NSNumber *)getSourceSize:(NSString *)path sizeStandard:(SIZE_STANDARD)standard {
    BOOL isDirectory;
    BOOL isExists = [self fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isExists) return [NSNumber numberWithUnsignedLongLong:0];
    if (isDirectory) {
        // 文件夹
        return [self getDirSize:path sizeStandard:standard];
    } else {
        // 文件
        return [self getFileSize:path sizeStandard:standard];
    }
}

/**
 获取文件/文件夹创建时间
 
 @param path 完整路径
 @param dateFormat 格式化格式, null输出NSDate
 */

/**
 获取文件/文件夹 时间属性

 @param type 时间类型
 @param path 完整路径
 @param dateFormat 时间格式
 @return 时间 / nil | string | date
 */
- (nullable id)getSourceTimeType:(FILE_TIME_ATTRIBUTE_TYPE)type
                        fullPath:(nonnull NSString *)path
                      dateFormat:(nullable NSString *)dateFormat {
    NSDictionary<NSFileAttributeKey, id> *fileInfo = [self attributesOfItemAtPath:path];
    if (fileInfo) {
        NSDate *date = nil;
        switch (type) {
            case FILE_TIME_ATTRIBUTE_TYPE_CREATE:
                date = fileInfo[NSFileCreationDate];
                break;
            case FILE_TIME_ATTRIBUTE_TYPE_MODIFY:
            case FILE_TIME_ATTRIBUTE_TYPE_LASTOPEN:
                date = [fileInfo fileModificationDate];
            default:
                return nil;
                break;
        }
        if (dateFormat) {
            LogWidgetManager.manager.gloableTool.dateFormatter.dateFormat = dateFormat;
            return [LogWidgetManager.manager.gloableTool.dateFormatter stringFromDate:date];
        }
        return date;
    } else {
        return nil;
    }
}


#pragma mark - getter & setter
- (nonnull NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
        NSLog(@"%s -- [%d]: manager had error by fileManager as NULL", __FUNCTION__, __LINE__);
    }
    return _fileManager;
}

#pragma mark - private function



@end
