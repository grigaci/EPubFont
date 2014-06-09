//
//  BIFileHelpers.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "BIFileHelpers.h"

@implementation BIFileHelpers

+ (NSString *)generateUniqueFilepathForFile:(NSString *)fileName {
    NSParameterAssert(fileName);
    
    fileName = [fileName lastPathComponent];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *generatedFileName;
    BOOL fileExists = YES;
    do {
        int randomNumber = rand();
        generatedFileName = [NSString stringWithFormat:@"%@/%@.%d", cacheDir, fileName, randomNumber];
        fileExists = [fileManager fileExistsAtPath:generatedFileName];
    } while (fileExists);
    
    return generatedFileName;
}

+ (void)deleteFile:(NSString *)filepath {
    NSParameterAssert(filepath);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filepath error:nil];
}

@end
