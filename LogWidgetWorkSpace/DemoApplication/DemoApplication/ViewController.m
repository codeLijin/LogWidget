//
//  ViewController.m
//  DemoApplication
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "ViewController.h"
#import <LogWidget/LogWidget.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LogWidgetManager *manager = [LogWidgetManager manager];
//    [manager.fileManager createFolder:@"ios/lijin" inPath:(DOCUMENT_PATH_DOCUMENT) clearIfNeeded:YES];
//    NSNumber *size = [manager.fileManager getPathSize:[manager.fileManager getFullPathBy:DOCUMENT_PATH_DOCUMENT relativePath:@"/ios/"] sizeStandard:(SIZE_STANDARD_MB)];
    NSString *fullPath = [manager.fileManager getFullPathBy:DOCUMENT_PATH_DOCUMENT relativePath:@"/ios/b/file.txt"];
    NSString *time = [manager.fileManager
                      getSourceTimeType:FILE_TIME_ATTRIBUTE_TYPE_CREATE
                      fullPath:fullPath
                      dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@", time);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
