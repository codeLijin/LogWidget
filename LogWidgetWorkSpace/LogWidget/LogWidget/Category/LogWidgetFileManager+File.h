//
//  LogWidgetFileManager+File.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/20.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <LogWidget/LogWidget.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogWidgetFileManager (File)

/**
 计算文件大小

 @param path 文件路径
 @param standard 计量单位
 @return 文件size: 计量单位区分 unsign long long | float | double
 */
- (NSNumber *)getFileSize:(NSString *)path sizeStandard:(SIZE_STANDARD)standard;

/**
 创建文件
 
 @param fileName 文件名称
 @param relativePath 相对路径
 @param inPath 根目录
 @param overwrite 是否重写
 @param baseData 初始数据
 @param error z错误信息
 @return 创建结果
 */
- (BOOL)createFile:(nonnull NSString *)fileName
      relativePath:(nonnull NSString *)relativePath
            inPath:(DOCUMENT_PATH)inPath
         overwrite:(BOOL)overwrite
          baseData:(NSData *)baseData
             error:(NSError *__autoreleasing *)error;

- (BOOL)writeFileAtFullPath:(NSString *)fullPath content:(NSObject *)content error:(NSError *__autoreleasing *)error;
@end

NS_ASSUME_NONNULL_END
