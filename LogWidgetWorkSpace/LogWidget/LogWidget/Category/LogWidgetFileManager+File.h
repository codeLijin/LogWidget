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
@end

NS_ASSUME_NONNULL_END