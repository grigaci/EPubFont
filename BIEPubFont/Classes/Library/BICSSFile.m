//
//  BICSSFile.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "OZLib.h"

#import "BICSSFile.h"
#import "BIFileHelpers.h"

@interface BICSSFile ()

@property (nonatomic, strong) OZFileInZipInfo *existingFileInfo;
@property (nonatomic, strong) OZZipReadStream *existingZipStream;

@property (nonatomic, copy, readwrite) NSString *epubCSSFilePath;
@property (nonatomic, copy, readwrite) NSString *temporaryFilePath;

@end

@implementation BICSSFile

#pragma mark - Constants

NSString * const kFontFamilyTag = @"font-family:";
NSString * const kCSSClassEndCharacter = @"}";
const NSUInteger kBufferReadBytesCount = 100;

#pragma mark - Public methods

+ (instancetype)cssFileFromFileInfo:(OZFileInZipInfo *)existingFileInfo
                  fileZipStreamRead:(OZZipReadStream *)existingZipStream {
    return [[[self class] alloc] initWithCSSFileFromFileInfo:existingFileInfo fileZipStreamRead:existingZipStream];
}

- (instancetype)initWithCSSFileFromFileInfo:(OZFileInZipInfo *)existingFileInfo
                          fileZipStreamRead:(OZZipReadStream *)existingZipStream {
    self = [super init];
    if (self) {
        self.existingFileInfo = existingFileInfo;
        self.existingZipStream = existingZipStream;
        self.epubCSSFilePath = self.existingFileInfo.name;
    }
    return self;
}

- (void)cloneOriginalCSSFile {
    NSUInteger readBytes = 0;
    do {
        NSMutableData *buffer = [[NSMutableData alloc] initWithLength:kBufferReadBytesCount];
        readBytes = [self.existingZipStream readDataWithBuffer:buffer error:nil];
        buffer.length = readBytes;
        [self appendDataInTempFile:buffer];
    } while (readBytes > 0);

    [self.existingZipStream finishedReading:nil];
}

- (void)writeCSSFileInZipStream:(OZZipWriteStream *)writeStream
                        forFont:(NSString *)fontName {
    NSUInteger offset = 0;
    NSUInteger chunkSize = 1024;     //Read 1KB chunks.
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:self.temporaryFilePath];
    NSData *data = [handle readDataOfLength:chunkSize];
    NSMutableString *stringToParse = [NSMutableString new];
    while ([data length] > 0) {
        NSString *readString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [stringToParse appendString:readString];
        
        NSMutableArray *cssClasses = [[stringToParse componentsSeparatedByString:kCSSClassEndCharacter] mutableCopy];
        NSString *lastCssClass = [cssClasses lastObject];
        if (lastCssClass) {
            stringToParse = [NSMutableString stringWithString:lastCssClass];
            [cssClasses removeLastObject];
        } else {
            stringToParse = [NSMutableString new];
        }
        
        for (NSString *cssClass in cssClasses) {
            NSString *parsedCSSClass = [self parseCSSClass:cssClass forFont:fontName];
            parsedCSSClass = [parsedCSSClass stringByAppendingString:kCSSClassEndCharacter];
            NSData *parsedData = [parsedCSSClass dataUsingEncoding:NSUTF8StringEncoding];
            [writeStream writeData:parsedData error:nil];
        }
        
        offset += [data length];
        [handle seekToFileOffset:offset];
        data = [handle readDataOfLength:chunkSize];
    }
    
    NSString *remainingString = [self parseCSSClass:stringToParse forFont:fontName];
    NSData *remainingData = [remainingString dataUsingEncoding:NSUTF8StringEncoding];
    [writeStream writeData:remainingData error:nil];

    [handle closeFile];
}

- (void)deleteTemporaryFile {
    [BIFileHelpers deleteFile:self.temporaryFilePath];
}

#pragma mark - Property methods

- (NSString *)temporaryFilePath {
    if (!_temporaryFilePath) {
        _temporaryFilePath = [BIFileHelpers generateUniqueFilepathForFile:self.existingFileInfo.name];
    }
    return _temporaryFilePath;
}

#pragma mark - Private methods

- (NSString *)zipFilePathForFont:(NSString *)fontName {
    NSString *currentZipPath = self.existingFileInfo.name;
    NSString *extension = [currentZipPath pathExtension];
    NSString *pathWithoutExtension = [currentZipPath stringByDeletingPathExtension];
    NSString *newFileName = [NSString stringWithFormat:@"%@-%@.%@", pathWithoutExtension, fontName, extension];
    return newFileName;
}

- (void)appendDataInTempFile:(NSData *)data {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self.temporaryFilePath]) {
        // In case the file is not exsiting.
        [data writeToFile:self.temporaryFilePath atomically:YES];
    } else {
        // Append data at the end.
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:self.temporaryFilePath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:data];
    }
}

- (NSString *)parseCSSClass:(NSString *)cssClass forFont:(NSString *)newFont {
    NSString *newCSSClass;
    NSError *error;
    
    NSString *regExPatterns = [NSString stringWithFormat:@"%@(?:(?![}|;]).)*", kFontFamilyTag];
    NSString *newFontTemplate = [NSString stringWithFormat:@"%@ %@", kFontFamilyTag, newFont];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExPatterns options:NSRegularExpressionCaseInsensitive error:&error];
    
    newCSSClass = [regex stringByReplacingMatchesInString:cssClass
                                                  options:0
                                                    range:NSMakeRange(0, [cssClass length])
                                             withTemplate:newFontTemplate];
    return newCSSClass;
}

@end
