//
//  ViewController.m
//  DemoApplication
//
//  Created by 李晋 on 2019/9/17.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <LogWidget/LogWidget.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LogWidgetManager *manager = [LogWidgetManager manager];
    
    NSString *path = [manager.fileManager getFullPathBy:DOCUMENT_PATH_DOCUMENT relativePath:@"/ios/a/"];
    NSLog(@"完整路径: \n\t%@", path);
    
    [manager.fileManager removeItemAtPath:path error:nil];
    NSLog(@"\n");
    
    /**
     创建文件
     YNPathModel *model = [YNPathModel modelWithOringinPath:path isDirectory:NO];
     model.pathExtension = @"lijin";
     */

    /**
     创建文件
     [manager.fileManager createFolder:@"ios/b/" inPath:(DOCUMENT_PATH_DOCUMENT) clearIfNeeded:YES];
     */
    
    /**
     文件属性
     NSNumber *size = [manager.fileManager getPathSize:[manager.fileManager getFullPathBy:DOCUMENT_PATH_DOCUMENT relativePath:@"/ios/"] sizeStandard:(SIZE_STANDARD_MB)];
     NSString *fullPath = [manager.fileManager getFullPathBy:DOCUMENT_PATH_DOCUMENT relativePath:@"/ios/b/file.txt"];
     NSString *time = [manager.fileManager
     getSourceTimeType:FILE_TIME_ATTRIBUTE_TYPE_CREATE
     fullPath:fullPath
     dateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSLog(@"%@", time);
     */
    
    /**
     创建文件测试
     NSString *str = @"d奇奇翁群翁群翁无群二群无无群无群二无群二群翁群翁群无群二无";
     BOOL result = [manager.fileManager createFile:@"123.jpg" relativePath:@"/ios/b/c" inPath:DOCUMENT_PATH_DOCUMENT overwrite:true baseData:nil];
     NSLog(@"result: %d", result);
     UIImage *img = [UIImage imageNamed:@"1"];
     */
    
    /**
     写文件测试
     Person *p = [[Person alloc] init];
     p.name = @"lijin";
     p.age = 18;
     p.dic = @{@"person": @"p_value"};
     [manager.fileManager writeFile:@"/person.txt" relativePath:@"/ios/b/c/" inPath:DOCUMENT_PATH_DOCUMENT content:p append:YES error:nil];
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
