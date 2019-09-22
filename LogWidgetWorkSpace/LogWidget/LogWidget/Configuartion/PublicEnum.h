//
//  PublicEnum.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/20.
//  Copyright © 2019 李晋. All rights reserved.
//

#ifndef PublicEnum_h
#define PublicEnum_h

/**
 文件路径

 - DOCUMENT_PATH_HOME: home / do not put your file to here well
 - DOCUMENT_PATH_DOCUMENT: document
 - DOCUMENT_PATH_LIBARAY: libaray
 - DOCUMENT_PATH_PREFERENCES: preferences
 - DOCUMENT_PATH_CACHE: cache
 - DOCUMENT_PATH_TMP: tmp
 */
typedef NS_ENUM(NSUInteger, DOCUMENT_PATH) {
    DOCUMENT_PATH_HOME = 0,
    DOCUMENT_PATH_DOCUMENT,
    DOCUMENT_PATH_LIBARAY,
    DOCUMENT_PATH_PREFERENCES,
    DOCUMENT_PATH_CACHE,
    DOCUMENT_PATH_TMP,
};

/**
 文件大小计量单位

 - SIZE_STANDARD_BIT: Number of unsigned long long
 - SIZE_STANDARD_KB: Number of float
 - SIZE_STANDARD_MB: Number of double
 - SIZE_STANDARD_GB: Number of double
 - SIZE_STANDARD_TB: Number of double
 */
typedef NS_ENUM(NSUInteger, SIZE_STANDARD) {
    SIZE_STANDARD_BIT = 0,
    SIZE_STANDARD_KB,
    SIZE_STANDARD_MB,
    SIZE_STANDARD_GB,
    SIZE_STANDARD_TB
};

/**
 文件时间属性

 - FILE_TIME_ATTRIBUTE_TYPE_CREATE: 创建时间
 - FILE_TIME_ATTRIBUTE_TYPE_MODIFY: 修改时间
 - FILE_TIME_ATTRIBUTE_TYPE_LASTOPEN: 最近打开时间
 */
typedef NS_ENUM(NSUInteger, FILE_TIME_ATTRIBUTE_TYPE) {
    FILE_TIME_ATTRIBUTE_TYPE_CREATE = 0,
    FILE_TIME_ATTRIBUTE_TYPE_MODIFY,
    FILE_TIME_ATTRIBUTE_TYPE_LASTOPEN,
};

// 创建文件夹, 如果已存在, 是否需要重新创建文件夹
typedef BOOL clearDir;

#endif /* PublicEnum_h */
