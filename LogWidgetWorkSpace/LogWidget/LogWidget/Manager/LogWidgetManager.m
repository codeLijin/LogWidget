//
//  LogWidgetManager.m
//  LogWidget
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "LogWidgetManager.h"
#import "LogWidgetFileManager.h"

@interface LogWidgetManager()
/**
 文件操作
 */
@property (nonatomic, readwrite, strong) LogWidgetFileManager *fileManager;
/**
 公用数据
 */
@property (nonatomic, readwrite, strong) LogWidgetGloableTool *gloableTool;

@end

@implementation LogWidgetManager
@synthesize fileManager = _fileManager;
@synthesize gloableTool = _gloableTool;

static LogWidgetManager *manager = nil;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = YNLogFileManager;
        self.gloableTool = [LogWidgetGloableTool tool];
    }
    return self;
}

#pragma mark - setter & getter
- (void)setFileManager:(LogWidgetFileManager *)fileManager {
    if (!fileManager) {
        return;
    }
    _fileManager = fileManager;
}

- (void)setGloableTool:(LogWidgetGloableTool *)gloableTool {
    if (!gloableTool) {
        return;
    }
    _gloableTool = gloableTool;
}

- (LogWidgetFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [LogWidgetFileManager fileManager];
    }
    return _fileManager;
}

- (LogWidgetGloableTool *)gloableTool {
    if (!_gloableTool) {
        _gloableTool = [LogWidgetGloableTool tool];
    }
    return _gloableTool;
}
@end
