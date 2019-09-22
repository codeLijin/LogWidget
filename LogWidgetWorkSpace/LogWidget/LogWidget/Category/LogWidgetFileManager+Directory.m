//
//  LogWidgetFileManager+Directory.m
//  LogWidget
//
//  Created by lijin743 on 2019/9/18.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "LogWidgetFileManager+Directory.h"
#import "LogWidgetFileManager+File.h"

@implementation LogWidgetFileManager (Directory)

/**
 创建文件夹
 
 @param folder 文件夹路径
 @param path 文件夹所在根目录
 @param clearIfNeeded 如果已存在, 是否重新创建
 @return 操作是否成功
 */
- (BOOL)createFolder:(nonnull NSString *)folder
              inPath:(DOCUMENT_PATH)path
       clearIfNeeded:(clearDir)clearIfNeeded {
    if (!folder || path > DOCUMENT_PATH_TMP) {
        return false;
    }
    NSError *error = nil;
    NSString *full_path = [self getFullPathBy:path relativePath:folder];
    // 是否为目录
    BOOL isDir = false;
    // 是否存在
    BOOL isDirExist = [self fileExistsAtPath:full_path isDirectory:&isDir];
    if (isDirExist) {
        if (isDir) {
            NSLog(@"存在: 为文件夹");
            if (!clearIfNeeded) {
                // 不需销毁, 直接返回
                return true;
            }
            BOOL isRemove = [self fileManager:self.fileManager removeItemAtPath:full_path error:&error];
            NSLog(@"%@", isRemove?@"删除成功" : @"删除失败");
            if (!isRemove) {        // 删除旧文件失败, 不影响文件操作, 返回true
                return true;
            }
        } else {
            NSLog(@"存在: 不为文件夹");
        }
    }
    NSLog(@"不存在, 创建");
    return [self fileManager:self.fileManager createFolder:full_path intermediateDirectories:YES error:&error];
}

/**
 创建文件夹
 
 @param path 文件夹路径
 @param intermediateDirectories 是否创建中间文件夹
 @param error 错误信息
 @return 是否创建成功
 */
- (BOOL)fileManager:(NSFileManager *_Nonnull)fileManager createFolder:(NSString *_Nonnull)path intermediateDirectories:(BOOL)intermediateDirectories error:(NSError *__autoreleasing *_Nullable)error {
    if (!fileManager || !path || !path.length) {
        NSLog(@"check you pragmas, you chouldn't make null or empty path - %s [%d] \n", __PRETTY_FUNCTION__, __LINE__);
        return false;
    }
    BOOL res = [fileManager createDirectoryAtPath:path
                           withIntermediateDirectories:intermediateDirectories
                                            attributes:@{NSFilePosixPermissions: @(0775)}
                                                 error:error?error:nil];
    if (*error) {
        NSLog(@"createDirectoryAtPath:withIntermediateDirectories:attributes:error - %s [%d] \n %@", __PRETTY_FUNCTION__, __LINE__, *error);
        return false;
    }
    if (res) {
        NSLog(@"文件夹 %@ 创建成功", path);
        return true;
    } else {
        NSLog(@"文件夹 %@ 创建失败", path);
        return false;
    }
}

/**
 删除文件夹
 
 @param path 文件夹路径
 @param error 错误信息
 @return 删除成功
 */
- (BOOL)fileManager:(NSFileManager *_Nonnull)fileManager removeItemAtPath:(NSString *_Nonnull)path error:(NSError *__autoreleasing *_Nullable)error {
    if (!fileManager || !path || !path.length) {
        return false;
    }
    BOOL isRemove = [fileManager removeItemAtPath:path error:error];
    if (*error) {
        NSLog(@"createDirectoryAtPath:withIntermediateDirectories:attributes:error - %s [%d] \n %@", __PRETTY_FUNCTION__, __LINE__, *error);
    }
    return isRemove;
}

- (NSNumber *)getDirSize:(NSString *)path sizeStandard:(SIZE_STANDARD)standard {
    // 文件夹
    NSEnumerator *childFilesEnumerator = [[self.fileManager subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    unsigned long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        switch (standard) {
            case SIZE_STANDARD_BIT:
                
                folderSize += [self getFileSize:fileAbsolutePath sizeStandard:standard].unsignedLongLongValue;
                break;
            case SIZE_STANDARD_KB:
                folderSize += ([self getFileSize:fileAbsolutePath sizeStandard:standard].floatValue * 1024);
                break;
            case SIZE_STANDARD_MB:
                folderSize += ([self getFileSize:fileAbsolutePath sizeStandard:standard].doubleValue * 1024 * 1024);
                break;
            case SIZE_STANDARD_GB:
                folderSize += ([self getFileSize:fileAbsolutePath sizeStandard:standard].doubleValue * 1024 * 1024 * 1024);
                break;
            case SIZE_STANDARD_TB:
                folderSize += ([self getFileSize:fileAbsolutePath sizeStandard:standard].doubleValue * 1024 * 1024 * 1024 * 1024);
                break;
            default:
                break;
        }
    }
    switch (standard) {
        case SIZE_STANDARD_BIT:
            return [NSNumber numberWithUnsignedLongLong:folderSize];
        case SIZE_STANDARD_KB:
            return [NSNumber numberWithFloat:(double)folderSize/1024.0];
        case SIZE_STANDARD_MB:
            return [NSNumber numberWithDouble:(double)folderSize / (1024.0 * 1024.0)];
        case SIZE_STANDARD_GB:
            return [NSNumber numberWithDouble:(double)folderSize / (1024.0 * 1024.0 * 1024.0)];
        case SIZE_STANDARD_TB:
            return [NSNumber numberWithDouble:((double)folderSize / (1024.0 * 1024.0 * 1024.0)) / 1024.0];
        default:
            return [NSNumber numberWithUnsignedLongLong:folderSize];
    }
}

@end
