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
/**
 读写文件队列
 */
@property (nonatomic, readwrite, strong) dispatch_queue_t rw_file_queue;
/**
 文件操作队列
 */
@property (nonatomic, readwrite, strong) dispatch_queue_t file_option_queue;
@end

@implementation LogWidgetFileManager

+ (nullable instancetype)fileManager {
    static LogWidgetFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.fileManager = [NSFileManager defaultManager];
        manager.rw_file_queue = dispatch_queue_create("com.jd.wirte.lijin", DISPATCH_QUEUE_SERIAL);
        manager.file_option_queue = dispatch_queue_create("com.jd.fileop.lijin", DISPATCH_QUEUE_SERIAL);
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

- (NSString *)directoryAtPath:(NSString *)path {
    if (path.length && [self fileExistsAtPath:path isDirectory:nil]) {
        return [path stringByDeletingLastPathComponent];
    }
    return nil;
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
                                  error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    BOOL isDirectory;
    if (![self fileExistsAtPath:sourceFullPath isDirectory:&isDirectory]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", sourceFullPath];
        return NO;
    }
    NSString *targetPath = [self getFullPathBy:toPath relativePath:toRelativePath];
    BOOL isSuccess = [self moveItemAtPath:sourceFullPath fullPath:targetPath overwrite:overwrite error:error];
    return isSuccess;
}

- (BOOL)moveItemAtPath:(NSString *)sourceFullPath
                              fullPath:(nullable NSString *)fullPath
                           overwrite:(BOOL)overwrite
                                  error:(NSError *__autoreleasing *)error {
    //获得目标文件的上级目录
    if (!fullPath.length) {
        return false;
    }
    NSString *toDirPath = [fullPath stringByDeletingLastPathComponent];
    if (!toDirPath.length) {
        return false;
    }
    BOOL isDirectory;
    if (![self fileExistsAtPath:toDirPath isDirectory:&isDirectory]) {
        // 创建移动路径
        if (![self createFolderFullPath:toDirPath clearIfNeeded:YES error:error]) {
            return NO;
        }
    }
    // 判断目标路径文件是否存在
    if ([self fileExistsAtPath:fullPath isDirectory:&isDirectory]) {
        //如果覆盖，删除目标路径文件
        if (overwrite) {
            //删掉目标路径文件
            [self removeItemAtPath:fullPath error:error];
        }else {
            //删掉被移动文件
            [self removeItemAtPath:sourceFullPath error:error];
            return YES;
        }
    }
    return [[NSFileManager defaultManager] moveItemAtPath:sourceFullPath toPath:fullPath error:error];
}

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
                            error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    BOOL isDirectory;
    if (![self fileExistsAtPath:sourceFullPath isDirectory:&isDirectory]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", sourceFullPath];
        return NO;
    }
    NSString *targetPath = [self getFullPathBy:toPath relativePath:toRelativePath];
    BOOL isSuccess = [self yn_copyItemAtPath:sourceFullPath fullPath:targetPath overwrite:overwrite error:error];
    return isSuccess;
    
    
}

- (BOOL)yn_copyItemAtPath:(NSString *)sourceFullPath
              fullPath:(nullable NSString *)fullPath
             overwrite:(BOOL)overwrite
                    error:(NSError *__autoreleasing *)error {
    //获得目标文件的上级目录
    if (!fullPath.length) {
        return false;
    }
    NSString *toDirPath = [fullPath stringByDeletingLastPathComponent];
    if (!toDirPath.length) {
        return false;
    }
    BOOL isDirectory;
    if (![self fileExistsAtPath:toDirPath isDirectory:&isDirectory]) {
        // 创建复制路径
        if (![self createFolderFullPath:toDirPath clearIfNeeded:YES error:error]) {
            return NO;
        }
    }
    
    // 如果覆盖，那么先删掉原文件
    if (overwrite) {
        if ([self fileExistsAtPath:fullPath isDirectory:&isDirectory]) {
            [self removeItemAtPath:fullPath error:error];
        }
    }
    // 复制文件，如果不覆盖且文件已存在则会复制失败
    return [[NSFileManager defaultManager] copyItemAtPath:sourceFullPath toPath:fullPath error:error];
}

#pragma mark - getter & setter
- (nonnull NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
        NSLog(@"%s -- [%d]: manager had error by fileManager as NULL", __FUNCTION__, __LINE__);
    }
    return _fileManager;
}

- (dispatch_queue_t)fileReadWriteQueue {
    return _rw_file_queue;
}

- (dispatch_queue_t)fileOperationQueue {
    return _file_option_queue;
}


#pragma mark - private function



@end
