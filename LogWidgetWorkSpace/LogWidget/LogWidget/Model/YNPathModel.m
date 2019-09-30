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

+ (instancetype)modelWithYNPath:(DOCUMENT_PATH)yn_PATH
                                yn_relativePath:(nullable NSString *)yn_relativePath
                                     yn_fileName:(nullable NSString *)yn_fileName
                                       isDirectory:(BOOL)isDirectory {
    if (yn_PATH > DOCUMENT_PATH_CACHE || yn_PATH < DOCUMENT_PATH_HOME) {
        return [[YNPathModel alloc] init];
    }
    return [[YNPathModel alloc] initWithYNPath:yn_PATH yn_relativePath:yn_relativePath yn_fileName:yn_fileName isDirectory:isDirectory];
}

- (instancetype)initWithOringinPath:(NSString *)oringinPath isDirectory:(BOOL)isDirectory {
    self = [super init];
    if (self) {
        _oringinPath = oringinPath;
        _directory = isDirectory;
        _yn_PATH = DOCUMENT_PATH_ERROR;
        [self _oringinPathMakeProperties];
//        [self _create];
    }
    return self;
}

- (instancetype)initWithYNPath:(DOCUMENT_PATH)yn_PATH
                          yn_relativePath:(NSString *)yn_relativePath
                               yn_fileName:(NSString *)yn_fileName
                                 isDirectory:(BOOL)isDirectory {
    self = [super init];
    if (self) {
        _yn_PATH = yn_PATH;
        _yn_relativePath = yn_relativePath;
        _yn_fileName = yn_fileName;
        _directory = isDirectory;
        [self _ynPathMakeProperties];
//        [self _create];
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
    {       // YN Properties
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
    if (_yn_PATH == DOCUMENT_PATH_ERROR) {
        return;
    }
    NSString *fullPath = [YNLogFileManager getFullPathBy:_yn_PATH relativePath:_yn_relativePath];
    if (!fullPath.length) {
        return;
    }
    // oringin Properties
    _oringinPath = [fullPath stringByAppendingPathComponent:_yn_fileName];
    _lastPathComponent = [_oringinPath lastPathComponent];
    _relativePath = [_oringinPath stringByAbbreviatingWithTildeInPath];
    _pathExtension = [_oringinPath pathExtension];
    _stringByDeletingPathExtension = [_oringinPath stringByDeletingPathExtension];
}


#pragma mark - public
- (BOOL)createClearIfNeeded:(BOOL)destroyIfNeeded {
    if (self.yn_PATH < DOCUMENT_PATH_ERROR && self.yn_PATH >= DOCUMENT_PATH_HOME) {
        if (self.isDirectory) {
            return [YNLogFileManager createFolder:self.yn_relativePath inPath:self.yn_PATH clearIfNeeded:destroyIfNeeded];
        } else {
            return [YNLogFileManager createFile:self.yn_fileName relativePath:self.yn_relativePath inPath:self.yn_PATH overwrite:destroyIfNeeded baseData:nil];
        }
    }
    return false;
}

- (void)yn_write:(nonnull NSObject *)content overwrite:(BOOL)overwrite completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion {
    if (!self.isDirectory) {
        __weak typeof(self) weakSelf = self;
        dispatch_async([YNLogFileManager fileReadWriteQueue], ^{
            __strong typeof(self) strongSelf = weakSelf;
            NSError *error;
            BOOL ret = [YNLogFileManager writeFile:strongSelf.yn_fileName relativePath:strongSelf.yn_relativePath inPath:strongSelf.yn_PATH content:content append:!overwrite error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(ret, error);
            });
        });
    } else {
        completion(NO, nil);
    }
}

- (void)yn_moveToYN_Path:(DOCUMENT_PATH)yn_PATH
                    toRelativePath:(NSString *)yn_relativePath
                            overwrite:(BOOL)overwrite
                         completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion {
    NSString *path = [YNLogFileManager getFullPathBy:yn_PATH relativePath:yn_relativePath];
    if (!path.length) {
        completion(NO, [NSError errorWithDomain:@"wrong target file" code:102 userInfo:nil]);
    } else {
        [self yn_moveToFullPath:path overwrite:overwrite completion:completion];
    }
}

- (void)yn_moveToFullPath:(NSString *)fullPath overwrite:(BOOL)overwrite completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion {
    __weak typeof(self) weakSelf = self;
    dispatch_async([YNLogFileManager fileOperationQueue], ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSError *error;
        BOOL result = [YNLogFileManager moveItemAtPath:strongSelf.oringinPath fullPath:fullPath overwrite:overwrite error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result, error);
        });
    });
}

- (void)yn_copyToYN_Path:(DOCUMENT_PATH)yn_PATH
                   toRelativePath:(NSString *)yn_relativePath
                            overwrite:(BOOL)overwrite
                         completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion {
    NSString *path = [YNLogFileManager getFullPathBy:yn_PATH relativePath:yn_relativePath];
    if (!path.length) {
        completion(NO, [NSError errorWithDomain:@"wrong target file" code:102 userInfo:nil]);
    } else {
        [self yn_copyToFullPath:path overwrite:overwrite completion:completion];
    }
}

- (void)yn_copyToFullPath:(NSString *)fullPath overwrite:(BOOL)overwrite completion:(void (^)(BOOL result, NSError *_Nullable __autoreleasing error))completion {
    __weak typeof(self) weakSelf = self;
    dispatch_async([YNLogFileManager fileOperationQueue], ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSError *error;
        BOOL result = [YNLogFileManager yn_copyItemAtPath:strongSelf.oringinPath fullPath:fullPath overwrite:overwrite error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result, error);
        });
    });
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
        _oringinPath = [_path__ stringByAppendingPathExtension:pathExtension]; //加入后缀名
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
