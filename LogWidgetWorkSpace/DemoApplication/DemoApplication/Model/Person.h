//
//  Person.h
//  DemoApplication
//
//  Created by lijin743 on 2019/9/28.
//  Copyright © 2019 李晋. All rights reserved.
//

#import <LogWidget/LogWidget.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : YNCodingModel

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) NSInteger age;
@property (nonatomic, readwrite, strong) NSDictionary *dic;

@end

NS_ASSUME_NONNULL_END
