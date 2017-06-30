//
//  FormFillSubpageViewController.h
//  zichan
//
//  Created by Mike on 16/6/26.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileBrowserViewControllerDelegate;

@interface FileBrowserViewController : UIViewController

@property (nonatomic, assign) BOOL lockRootFolder;
@property (nonatomic, weak) id<FileBrowserViewControllerDelegate> fileBrowserViewControllerDelegate;

- (instancetype)initWithPath:(NSString *)path;

@end

@protocol FileBrowserViewControllerDelegate <NSObject>

- (void)fileBrowserViewController:(FileBrowserViewController *)viewController didSelectFileWithPath:(NSString *)path fileAttributes:(NSDictionary *)fileAttributes;

@end
