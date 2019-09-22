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

@end
