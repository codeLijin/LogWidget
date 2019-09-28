//
//  NSDictionary+YNCoding.h
//  LogWidget
//
//  Created by lijin743 on 2019/9/27.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (YNCoding)

- (NSString*)yn_toJsonString:(NSError *__autoreleasing *)error;

- (NSData *)yn_toJsonData:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
