//
//  LogWidgetGloableTools.m
//  LogWidget
//
//  Created by 李晋 on 2019/9/21.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "LogWidgetGloableTool.h"

@interface LogWidgetGloableTool ()

@property (nonatomic, readwrite, strong) NSDateFormatter *dateFormatter;
@end

@implementation LogWidgetGloableTool
@synthesize dateFormatter = _dateFormatter;

+ (instancetype)tool {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

#pragma mark - setter & getter
- (void)setDateFormatter:(NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        return;
    }
    _dateFormatter = dateFormatter;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
@end
