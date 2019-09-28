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
- (NSString *)getFullPathBy:(DOCUMENT_PATH)path relativePath:(nullable NSString *)relativePath {
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
        case DOCUMENT_PATH_TMP:
            pre_path = [NSFileManager tmpPath];
            break;
        case DOCUMENT_PATH_PREFERENCES:
            pre_path = [NSFileManager preferencesPath];
            break;
        case DOCUMENT_PATH_CACHE:
            pre_path = [NSFileManager cachePath];
            break;
        case DOCUMENT_PATH_ERROR:
            return nil;
        default:
            // TODO: get Path Error, Make AlertView Show On
            return nil;
            break;
    }
    if (!pre_path) {
        return pre_path;
    }
    if (relativePath.length) {
        pre_path = [pre_path stringByAppendingPathComponent:relativePath];
    }
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

/**
 删除文件(夹)
 
 @param path 文件夹路径
 @param error 错误信息
 @return 删除成功
 */
- (BOOL)removeItemAtPath:(NSString *_Nonnull)path error:(NSError *__autoreleasing *_Nullable)error {
    if (!self.fileManager || !path || !path.length) {
        return false;
    }
    BOOL isRemove = [_fileManager removeItemAtPath:path error:error];
    if (error && *error) {
        NSLog(@"createDirectoryAtPath:withIntermediateDirectories:attributes:error - %s [%d] \n %@", __PRETTY_FUNCTION__, __LINE__, *error);
    }
    return isRemove;
}

#pragma mark - 移动文件(夹)
/*参数1、被移动文件路径
 *参数2、要移动到的目标文件路径
 *参数3、当要移动到的文件路径文件存在，会移动失败，这里传入是否覆盖
 *参数4、错误信息
 + (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
 https://www.jianshu.com/p/d7050b1fe978
 // 先要保证源文件路径存在，不然抛出异常
 if (![self isExistsAtPath:path]) {
 [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
 return NO;
 }
 //获得目标文件的上级目录
 NSString *toDirPath = [self directoryAtPath:toPath];
 if (![self isExistsAtPath:toDirPath]) {
 // 创建移动路径
 if (![self createDirectoryAtPath:toDirPath error:error]) {
 return NO;
 }
 }
 // 判断目标路径文件是否存在
 if ([self isExistsAtPath:toPath]) {
 //如果覆盖，删除目标路径文件
 if (overwrite) {
 //删掉目标路径文件
 [self removeItemAtPath:toPath error:error];
 }else {
 //删掉被移动文件
 [self removeItemAtPath:path error:error];
 return YES;
 }
 }
 
 // 移动文件，当要移动到的文件路径文件存在，会移动失败
 BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
 
 return isSuccess;
 }
 */

#pragma mark - 复制文件(夹)
/*参数1、被复制文件(夹)路径
 *参数2、要复制到的目标文件路径
 *参数3、当要复制到的文件路径文件存在，会复制失败，这里传入是否覆盖
 *参数4、错误信息
 + (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
 // 先要保证源文件路径存在，不然抛出异常
 if (![self isExistsAtPath:path]) {
 [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
 return NO;
 }
 //获得目标文件的上级目录
 NSString *toDirPath = [self directoryAtPath:toPath];
 if (![self isExistsAtPath:toDirPath]) {
 // 创建复制路径
 if (![self createDirectoryAtPath:toDirPath error:error]) {
 return NO;
 }
 }
 // 如果覆盖，那么先删掉原文件
 if (overwrite) {
 if ([self isExistsAtPath:toPath]) {
 [self removeItemAtPath:toPath error:error];
 }
 }
 // 复制文件，如果不覆盖且文件已存在则会复制失败
 BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
 
 return isSuccess;
 }
 */

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
