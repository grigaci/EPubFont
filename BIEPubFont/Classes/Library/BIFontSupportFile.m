//
//  BIFontSupportFile.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "OZLib.h"

#import "BIFontSupportFile.h"

@interface BIFontSupportFile ()

@property (nonatomic, strong) NSDictionary *cssFilesDictionary;

@end

@implementation BIFontSupportFile

#pragma mark - Public methods

+ (instancetype)fontSupportFileFromReadStream:(OZZipReadStream *)readStream {
    return [[self alloc] initFontSupportFileFromReadStream:readStream];
}

- (instancetype)initFontSupportFileFromReadStream:(OZZipReadStream *)readStream {
    self = [super init];
    if (self) {
        [self readDataFromZipStream:readStream];
    }
    return self;
}

+ (instancetype)fontSupportFromDictionary:(NSDictionary *)dictionary toWriteStream:(OZZipWriteStream *)writeStream {
    return [[[self class] alloc] initFontSupportFromDictionary:dictionary toWriteStream:writeStream];
}

- (instancetype)initFontSupportFromDictionary:(NSDictionary *)dictionary toWriteStream:(OZZipWriteStream *)writeStream {
    self = [super init];
    if (self) {
        self.cssFilesDictionary = dictionary;
        [self writeDataIntoZipStream:writeStream];
    }
    return self;
}

- (NSArray *)allOriginalCSSFiles {
    return [self.cssFilesDictionary allKeys];
}

- (NSArray *)allCustomCSSFilesFor:(NSString *)pathToOriginaCSSFile {
    return self.cssFilesDictionary[pathToOriginaCSSFile];
}

#pragma mark - Private methods

- (void)writeDataIntoZipStream:(OZZipWriteStream *)writeStream {
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.cssFilesDictionary
                                                              format:NSPropertyListBinaryFormat_v1_0
                                                             options:0
                                                               error:NULL];
    [writeStream writeData:data error:nil];
}

- (void)readDataFromZipStream:(OZZipReadStream *)readStream {
    const NSUInteger size = 1024;
    NSMutableData *mutableData = [[NSMutableData alloc] initWithLength:size];
    NSInteger readBytes;
    do {
        NSMutableData *tempBuffer = [[NSMutableData alloc] initWithLength:size];
         readBytes = [readStream readDataWithBuffer:mutableData error:nil];
        tempBuffer.length = readBytes;
        [mutableData appendData:tempBuffer];
    } while (readBytes > 0);

    self.cssFilesDictionary = [NSPropertyListSerialization propertyListWithData:mutableData
                                                                        options:0
                                                                         format:NULL
                                                                          error:NULL];
}

@end
