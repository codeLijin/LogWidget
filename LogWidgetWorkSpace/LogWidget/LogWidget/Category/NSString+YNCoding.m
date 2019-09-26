//
//  NSString+Coding.m
//  LogWidget
//
//  Created by 李晋 on 2019/9/26.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "NSString+YNCoding.h"

@implementation NSString (YNCoding)

- (NSData *)utf8Data {
    if (self && self.length) {
        return [self dataUsingEncoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
