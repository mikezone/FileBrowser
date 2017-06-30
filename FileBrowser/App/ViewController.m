//
//  ViewController.m
//  FileBrowser
//
//  Created by Mike on 16/8/1.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ViewController.h"
#import "FileBrowserViewController.h"
#import "FileExtensionMIMEMapping.h"
#import "MIMEString.h"

@interface ViewController () <FileBrowserViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self setUI];
}

- (void)createUI {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 40)];
    [button setTitle:@"push" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)buttonDidClicked:(UIButton *)sender {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    FileBrowserViewController *vc = [[FileBrowserViewController alloc] initWithPath:path];
//    vc.lockRootFolder = YES; // or use default value `NO`
    vc.fileBrowserViewControllerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FileBrowserViewControllerDelegate

- (void)fileBrowserViewController:(FileBrowserViewController *)viewController didSelectFileWithPath:(NSString *)path fileAttributes:(NSDictionary *)fileAttributes {
    NSLog(@"%@", fileAttributes);
    if ([path pathExtension]) {
        NSLog(@"%@", [path pathExtension]);
        NSLog(@"%@", [MIMEString MIMEStringWithFileExtension:[path pathExtension]]);
    }
    NSLog(@"%@", [MIMEString MIMEStringWithFilePath:path]);
}

@end
