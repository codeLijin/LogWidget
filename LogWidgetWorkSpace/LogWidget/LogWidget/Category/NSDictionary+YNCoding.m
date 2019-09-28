//
//  NSDictionary+YNCoding.m
//  LogWidget
//
//  Created by lijin743 on 2019/9/27.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "NSDictionary+YNCoding.h"

@implementation NSDictionary (YNCoding)

- (NSString*)yn_toJsonString:(NSError *__autoreleasing *)error {
    if (!self) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                                                                  options:NSJSONWritingPrettyPrinted // If that option is not set, the most compact possible JSON will be generated
                                                                                                      error:error];
    if (!jsonData) {
        NSLog(@"%s  [%d] -- %@", __FUNCTION__, __LINE__, *error);
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    return jsonString;
}

- (NSData *)yn_toJsonData:(NSError *__autoreleasing *)error {
    NSString *json = [self yn_toJsonString:error];
    if (json && json.length) {
        return [json yn_utf8Data];
    }
    return nil;
}

@end
