//
//  NSBundle+FullPath.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "NSBundle+FullPath.h"

@implementation NSBundle (FullPath)

- (NSString *)fullPathForFile:(NSString *)fileName {
    NSString *extension = [fileName pathExtension];
    NSString *fileWithoutExtension = [fileName stringByDeletingPathExtension];
    NSString *fullPath = [self pathForResource:fileWithoutExtension ofType:extension inDirectory:@"EPubs"];
    return fullPath;
}

@end
