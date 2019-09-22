//
//  LogWidgetGloableTools.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/21.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogWidgetGloableTool : NSObject
@property (nonatomic, readonly, strong) NSDateFormatter *dateFormatter;

+ (instancetype)tool;
- (instancetype)init __attribute__((unavailable("use + (instancetype)tool")));
+ (instancetype)new __attribute__((unavailable("use + (instancetype)tool")));
@end

NS_ASSUME_NONNULL_END
