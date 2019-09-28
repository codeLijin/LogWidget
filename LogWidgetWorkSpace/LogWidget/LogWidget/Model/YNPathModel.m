//
//  YNPathModel.m
//  LogWidget
//
//  Created by lijin743 on 2019/9/28.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "YNPathModel.h"

@interface YNPathModel ()

/**
 是否为文件夹
 */
@property (nonatomic, readwrite, assign, getter=isDirectory) BOOL directory;
@end

@implementation YNPathModel
@synthesize lastPathComponent = _lastPathComponent;
@synthesize oringinPath = _oringinPath;

+ (instancetype)modelWithOringinPath:(NSString *)oringinPath isDirectory:(BOOL)isDirectory {
    YNPathModel *model = [[self alloc] initWithOringinPath:oringinPath isDirectory:isDirectory];
    return model;
}

+ (instancetype)modelWithYNPath:(DOCUMENT_PATH)yn_PATH yn_relativePath:(NSString *)yn_relativePath yn_fileName:(NSString *)yn_fileName {
    if (yn_PATH > DOCUMENT_PATH_CACHE || yn_PATH < DOCUMENT_PATH_HOME) {
        return [[YNPathModel alloc] init];
    }
    return [[YNPathModel alloc] initWithYNPath:yn_PATH yn_relativePath:yn_relativePath yn_fileName:yn_fileName];
}

- (instancetype)initWithOringinPath:(NSString *)oringinPath isDirectory:(BOOL)isDirectory {
    self = [super init];
    if (self) {
        _oringinPath = oringinPath;
        _directory = isDirectory;
        _yn_PATH = DOCUMENT_PATH_ERROR;
        [self _oringinPathMakeProperties];
    }
    return self;
}

- (instancetype)initWithYNPath:(DOCUMENT_PATH)yn_PATH yn_relativePath:(NSString *)yn_relativePath yn_fileName:(NSString *)yn_fileName {
    self = [super init];
    if (self) {
        _yn_PATH = yn_PATH;
        _yn_relativePath = yn_relativePath;
        _yn_fileName = yn_fileName;
        [self _ynPathMakeProperties];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _yn_PATH = DOCUMENT_PATH_ERROR;
    }
    return self;
}

#pragma mark - Private
- (void)_oringinPathMakeProperties {
//    if (!_oringinPath.length) {
//        return;
//    }
    _lastPathComponent = [_oringinPath lastPathComponent];
    _relativePath = [_oringinPath stringByAbbreviatingWithTildeInPath];
    _pathExtension = [_oringinPath pathExtension];
    _stringByDeletingPathExtension = [_oringinPath stringByDeletingPathExtension];
    {
        DOCUMENT_PATH PATH = _yn_PATH = DOCUMENT_PATH_ERROR;
        while ((PATH--) >= DOCUMENT_PATH_HOME && _oringinPath.length) {
            NSString *prefixHeader = [YNLogFileManager getFullPathBy:PATH relativePath:nil];
            if ([_oringinPath hasPrefix:prefixHeader]) {
                _yn_PATH = PATH;
                if (_directory) {                       // 文件夹
                    _yn_fileName = nil;
                    _yn_relativePath = [_oringinPath substringFromIndex:prefixHeader.length];
                } else {                                    // 文件
                    _yn_fileName = _lastPathComponent;
                    _yn_relativePath = [[_oringinPath stringByDeletingLastPathComponent] substringFromIndex:prefixHeader.length];
                }
                break;
            };
        }
    }
}

- (void)_ynPathMakeProperties {
    /// TODO: 属性转化 yn->origin
}

#pragma mark - Setter
- (void)setOringinPath:(NSString *)oringinPath {
    _oringinPath = oringinPath;
    [self _oringinPathMakeProperties];
}
- (void)setLastPathComponent:(NSString *)lastPathComponent {
    if (!lastPathComponent.length) {
        return;
    }
    NSString *stringByDeletingLastPathComponent = [_oringinPath stringByDeletingLastPathComponent];
    _oringinPath = [stringByDeletingLastPathComponent stringByAppendingPathComponent:lastPathComponent];
    [self _oringinPathMakeProperties];
}

- (void)setPathExtension:(NSString * _Nonnull)pathExtension {
    NSString *_path__ = _oringinPath;
    if (self.stringByDeletingPathExtension.length) {
        _path__ = [_oringinPath stringByDeletingPathExtension]; //去掉后缀名
    }
    if (!pathExtension.length) {
        _oringinPath = _path__;
    } else {
        _oringinPath = [_oringinPath stringByAppendingPathExtension:pathExtension]; //加入后缀名
    }
    [self _oringinPathMakeProperties];
}

#pragma mark - Getter
- (NSString *)oringinPath {
    return _oringinPath;
}
- (NSString *)lastPathComponent {
    return _lastPathComponent;
}
@end
//相对路径变成绝对路径
//NSString *stringByExpandingTildeInPath = [stringByAbbreviatingWithTildeInPath stringByExpandingTildeInPath];
