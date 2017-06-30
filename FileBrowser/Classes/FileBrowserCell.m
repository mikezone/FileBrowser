//
//  FileBrowserCell.m
//  FileBrowser
//
//  Created by Mike on 16/8/1.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FileBrowserCell.h"
#import "MIMEString.h"

@interface FileBrowserCell ()

//@property (nonatomic, weak) UIImageView *fileTypeImageView;

@end

@implementation FileBrowserCell

- (void)setFullPath:(NSString *)fullPath {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [defaultManager attributesOfItemAtPath:fullPath error:NULL];
    NSString *fileType = [fileAttributes fileType];
    if ([fileType isEqualToString:NSFileTypeDirectory]) {
        self.imageView.image = [UIImage imageNamed:@"folder_icon"];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([fileType isEqualToString:NSFileTypeRegular]) {
        NSString *mimeString = [MIMEString MIMEStringWithFilePath:fullPath];
        if ([mimeString hasPrefix:@"text/"]) {
            self.imageView.image = [UIImage imageNamed:@"doc_icon"];
        } else if ([mimeString hasPrefix:@"image/"]) {
            self.imageView.image = [UIImage imageNamed:@"image_icon"];
        } else if ([mimeString hasPrefix:@"application/"]) {
            if ([mimeString isEqualToString:@"application/octet-stream"]) {
                self.imageView.image = [UIImage imageNamed:@"other_icon"];
            }
        } else if ([mimeString hasPrefix:@"audio/"]) {
        
        } else if ([mimeString hasPrefix:@"video/"]) {
        
        } else if ([mimeString hasPrefix:@"drawing/"]) {
            
        } else if ([mimeString hasPrefix:@"message/"]) {
        
        } else { // other
            self.imageView.image = [UIImage imageNamed:@"other_icon"];
        }
    } else {
        self.imageView.image = [UIImage imageNamed:@"other_icon"];
    }
}

@end
