//
//  MIMEString.h
//  FileBrowser
//
//  Created by Mike on 16/8/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMEString : NSObject

+ (NSString *)MIMEStringWithFilePath:(NSString *)filePath;
+ (NSString *)MIMEStringWithFileExtension:(NSString *)fileExtension; // often return nil

@end
