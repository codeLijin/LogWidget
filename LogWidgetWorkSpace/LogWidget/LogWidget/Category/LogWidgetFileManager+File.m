//
//  LogWidgetFileManager+File.m
//  LogWidget
//
//  Created by 李晋 on 2019/9/20.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "LogWidgetFileManager+File.h"
@implementation LogWidgetFileManager (File)

/**
 获取文件大小

 @param path 文件完整路径
 @param standard 计量单位
 @return 文件大小 计量单位取值
 */
- (NSNumber *)getFileSize:(NSString *)path sizeStandard:(SIZE_STANDARD)standard {
    BOOL isDirectory;
    [self fileExistsAtPath:path isDirectory:&isDirectory];
    if (isDirectory) return [NSNumber numberWithUnsignedLongLong:0];
    // 文件
    NSDictionary<NSFileAttributeKey, id> *fileInfo = [self attributesOfItemAtPath:path];
    if (fileInfo) {
        unsigned long long file_size = [fileInfo fileSize];
        switch (standard) {
            case SIZE_STANDARD_BIT:
                return [NSNumber numberWithUnsignedLongLong:file_size];
            case SIZE_STANDARD_KB:
                return [NSNumber numberWithFloat:(float)file_size/1024.0];
            case SIZE_STANDARD_MB:
                return [NSNumber numberWithDouble:(double)file_size / (1024.0 * 1024.0)];
            case SIZE_STANDARD_GB:
                return [NSNumber numberWithDouble:(double)file_size / (1024.0 * 1024.0 * 1024.0)];
            case SIZE_STANDARD_TB:
                return [NSNumber numberWithDouble:((double)file_size / (1024.0 * 1024.0 * 1024.0)) / 1024.0];
            default:
                return [NSNumber numberWithUnsignedLongLong:file_size];
        }
    } else {
        return [NSNumber numberWithUnsignedLongLong:0];
    }
}


/**
 文件所在文件夹路径

 @param fullPath 文件完整路径
 @return 文件夹路径
 */
- (NSString *)directoryAtPath:(NSString *)fullPath {
    return [fullPath stringByDeletingLastPathComponent];
}

/**
 创建文件

 @param fileName 文件名称
 @param relativePath 相对路径
 @param inPath 根目录
 @param overwrite 是否重写
 @param baseData 初始数据
 @return 创建结果
 */
- (BOOL)createFile:(nonnull NSString *)fileName
      relativePath:(nonnull NSString *)relativePath
            inPath:(DOCUMENT_PATH)inPath
         overwrite:(BOOL)overwrite
          baseData:(nullable NSData *)baseData {
    // 如果文件夹路径不存在，那么先创建文件夹
    NSString *fullPath = [self getFullPathBy:inPath relativePath:relativePath];
    BOOL isDirectory;
    if ([self fileExistsAtPath:fullPath isDirectory:&isDirectory] == NO) {                // 目标目录不存在
        NSLog(@"无此文件夹: 创建");
        if (![self createFolder:relativePath inPath:inPath clearIfNeeded:NO]) {
            return NO;
        }
    } else {                                                                                                                    // 目标目录已存在
        if (isDirectory == NO) {                                                                // 不是文件夹, 不操作, 返回错误
            NSLog(@"有此文件: 不是文件夹, 错误");
            return false;
        }
    }
    NSString *file_full_path = [fullPath stringByAppendingPathComponent:fileName];
    if ([self fileExistsAtPath:file_full_path isDirectory:&isDirectory] == YES) {
        // 文件存在
        if (isDirectory == YES) {
            // 目标为文件夹, 不操作, 返回错误
            return false;
        }
        if (NO == overwrite) {      // 不覆盖
            return true;
        }
    }
    return [self.fileManager createFileAtPath:file_full_path contents:baseData attributes:nil];
}

/**
 写文件(覆盖)

 @param fileName 文件名称
 @param relativePath 相对路径
 @param inPath 根目录
 @param content 文件内容
 @param error 错误信息
 @return 写入结果
 */
- (BOOL)writeFile:(nonnull NSString *)fileName
     relativePath:(nonnull NSString *)relativePath
           inPath:(DOCUMENT_PATH)inPath
          content:(NSObject *)content
            error:(NSError *__autoreleasing *)error {
    //判断文件内容是否为空
    if (!content) {
        [NSException raise:@"非法的文件内容" format:@"文件内容不能为nil"];
        return NO;
    }
    //判断文件(夹)是否存在
    BOOL isDirectory;
    NSString *fullPath = [[self getFullPathBy:inPath relativePath:relativePath] stringByAppendingPathComponent:fileName];
    BOOL isExists = [self fileExistsAtPath:fullPath isDirectory:&isDirectory];
    if (!isExists) {            // 文件不存在
        if (!(isExists = [self createFile:fileName relativePath:relativePath inPath:inPath overwrite:YES baseData:nil])) {
            return NO;
        }
    } else {                    // 文件已存在
        if (isDirectory) {
            [NSException raise:@"目标文件为文件夹" format:@"填写正确的文件"];
            return false;
        }
    }
    if (isExists && !isDirectory) {
        if ([content isKindOfClass:[NSMutableArray class]]) {//文件内容为可变数组
            [(NSMutableArray *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSArray class]]) {//文件内容为不可变数组
            [(NSArray *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSMutableData class]]) {//文件内容为可变NSMutableData
            [(NSMutableData *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSData class]]) {//文件内容为NSData
            [(NSData *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSMutableDictionary class]]) {//文件内容为可变字典
            [(NSMutableDictionary *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSDictionary class]]) {//文件内容为不可变字典
            [(NSDictionary *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSJSONSerialization class]]) {//文件内容为JSON类型
            [(NSDictionary *)content writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSMutableString class]]) {//文件内容为可变字符串
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[NSString class]]) {//文件内容为不可变字符串
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:YES];
        }else if ([content isKindOfClass:[UIImage class]]) {//文件内容为图片
            [UIImagePNGRepresentation((UIImage *)content) writeToFile:fullPath atomically:YES];
        }else if ([content conformsToProtocol:@protocol(NSCoding)]) {//文件归档
            [NSKeyedArchiver archiveRootObject:content toFile:fullPath];
        }else {
            [NSException raise:@"非法的文件内容" format:@"文件类型%@异常，无法被处理。", NSStringFromClass([content class])];
            return NO;
        }
    }else {
        return NO;
    }
    return YES;
}

@end
