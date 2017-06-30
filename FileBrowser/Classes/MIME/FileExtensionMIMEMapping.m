
//
//  FileExtensionMIMEMapping.m
//  FileBrowser
//
//  Created by Mike on 16/8/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FileExtensionMIMEMapping.h"


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
@import CoreServices;
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif

@implementation FileExtensionMIMEMapping

//GSSynthesizeSingleton(GS, FileTypeMappings);

+ (nullable NSArray<NSString *> *)extensionsForMIMEType:(nullable NSString *)MIMEType {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, NULL);
    if (!UTI) {
        return nil;
    }
    CFArrayRef (*UTTypeCopyAllTagsWithClassPtr)(CFStringRef, CFStringRef);
    UTTypeCopyAllTagsWithClassPtr = UTTypeCopyAllTagsWithClass;
    CFArrayRef extensions;
    if (UTTypeCopyAllTagsWithClassPtr) {
        // OS X 10.10 / iOS 8.0 / watchOS 2.0 or later
        extensions = (*UTTypeCopyAllTagsWithClassPtr)(UTI, kUTTagClassFilenameExtension);
    } else {
        // OS X 10.9.x / iOS 7.x or earlier
        CFStringRef extension = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassFilenameExtension);
        CFIndex numValues = extension ? 1 : 0;
        extensions = CFArrayCreate(NULL, (void *)&extension, numValues, &kCFTypeArrayCallBacks);
        if (extension) {
            CFRelease(extension);
        }
    }
    CFRelease(UTI);
    return (__bridge_transfer NSArray *)extensions;
}

+ (nullable NSString *)preferredExtensionForMIMEType:(nullable NSString *)MIMEType {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, NULL);
    if (!UTI) {
        return nil;
    }
    CFStringRef extension = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassFilenameExtension);
    CFRelease(UTI);
    return (__bridge_transfer NSString *)extension;
}

+ (nullable NSString *)MIMETypeForExtension:(nullable NSString *)extension {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    if (!UTI) {
        return nil;
    }
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return (__bridge_transfer NSString *)MIMEType;
}

@end
