//
//  FileExtensionMIMEMapping.h
//  FileBrowser
//
//  Created by Mike on 16/8/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileExtensionMIMEMapping : NSObject

+ (nullable NSArray<NSString *> *)extensionsForMIMEType:(nullable NSString *)MIMEType;

+ (nullable NSString *)preferredExtensionForMIMEType:(nullable NSString *)MIMEType;

+ (nullable NSString *)MIMETypeForExtension:(nullable NSString *)extension;

@end
