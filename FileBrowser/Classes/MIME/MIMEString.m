//
//  MIMEString.m
//  FileBrowser
//
//  Created by Mike on 16/8/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MIMEString.h"
#import "FileExtensionMIMEMapping.h"

@implementation MIMEString

+ (NSString *)MIMEStringWithFilePath:(NSString *)filePath {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    request.HTTPMethod = @"HEAD";
    NSURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) return nil;
    return response.MIMEType.copy;
}

+ (NSString *)MIMEStringWithFileExtension:(NSString *)fileExtension {
    return [FileExtensionMIMEMapping MIMETypeForExtension:fileExtension];
}

@end
