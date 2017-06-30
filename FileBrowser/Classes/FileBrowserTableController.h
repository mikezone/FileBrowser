//
//  FileBrowserTableController.h
//  FileBrowser
//
//  Created by Mike on 16/8/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileBrowserDelegate;

@interface FileBrowserTableController : UIViewController

@property (nonatomic, copy) NSString *path;
@property (nonatomic, weak) id<FileBrowserDelegate> fileBrowserDelegate;

- (void)reloadData;

@end

@protocol FileBrowserDelegate <NSObject>

- (void)fileBrowserTableController:(FileBrowserTableController *)tableController didSelectFileWithPath:(NSString *)path fileAttributes:(NSDictionary *)fileAttributes;

- (void)fileBrowserTableController:(FileBrowserTableController *)tableController didSelectFolderWithPath:(NSString *)path;

@end
