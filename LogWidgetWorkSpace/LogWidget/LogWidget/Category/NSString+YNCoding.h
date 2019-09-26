//
//  NSString+Coding.h
//  LogWidget
//
//  Created by 李晋 on 2019/9/26.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YNCoding)

- (NSData *)utf8Data;

@end

NS_ASSUME_NONNULL_END
