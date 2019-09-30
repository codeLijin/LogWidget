//
//  LogWidgetManager.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>
#define YNLogWidgetManager [LogWidgetManager manager]

@class LogWidgetFileManager;
@class LogWidgetGloableTool;

NS_ASSUME_NONNULL_BEGIN

@interface LogWidgetManager : NSObject

+ (instancetype)manager;
- (instancetype)init __attribute__((unavailable("use +(instancetype)manager")));
+ (instancetype)new __attribute__((unavailable("use +(instancetype)manager")));

/**
 文件操作
 */
@property (nonatomic, readonly, strong) LogWidgetFileManager *fileManager;
/**
 公用数据
 */
@property (nonatomic, readonly, strong) LogWidgetGloableTool *gloableTool;

@end

NS_ASSUME_NONNULL_END
