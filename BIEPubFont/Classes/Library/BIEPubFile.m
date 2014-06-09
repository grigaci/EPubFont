//
//  BIEPubFile.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "OZLib.h"

#import "BIEPubFile.h"
#import "BIFontSupportFile.h"
#import "BICSSFile.h"

@interface BIEPubFile ()

@property (nonatomic, copy) NSString *epubFilePath;
@property (nonatomic, strong, readwrite) BIFontSupportFile *fontSupportFile;

@end

@implementation BIEPubFile

#pragma mark - Constants

NSString * const kFontSupportFileName = @"BIEPubFontLib.plist";
NSString * const kCSSExtension = @"css";

#pragma mark - Public methods

+ (instancetype)epubFileAtPath:(NSString *)path {
    return [[[self class] alloc] initEPubFileAtPath:path];
}

- (instancetype)initEPubFileAtPath:(NSString *)path {
    self = [super init];
    if (self) {
        self.epubFilePath = path;
    }
    return self;
}

- (BOOL)doesEPubContainFontSupportFile {
    return self.fontSupportFile ? YES : NO;
}

- (BIFontSupportFile *)fontSupportFile {
    if (!_fontSupportFile) {
        _fontSupportFile = [self fontSupportFileFromZip];
    }
    return _fontSupportFile;
}

- (BIFontSupportFile *)createFontSupportFileForFonts:(NSOrderedSet *)fonts {

    NSParameterAssert(fonts);
    NSParameterAssert([fonts count]);

    // First we extract all .css files from epub into Cache folder. We'll delete those files after we're done.
    NSOrderedSet *cssFiles = [self duplicateCSSFilesInEPub];

    // Reading each temporary file that we created earlier.
    NSMutableDictionary *fontSupportDictionary = [NSMutableDictionary new];
    OZZipFile *zipFileWrite = [[OZZipFile alloc] initWithFileName:self.epubFilePath mode:OZZipFileModeAppend];
    
    // For each font specified we create a new duplicated css file and write it into zip.
    for (BICSSFile *cssFile in cssFiles) {
        NSMutableArray *newFontFilePathsArray = [NSMutableArray new];
        for (NSString *fontName in fonts) {
            NSString *newCSSFileNameInZip = [self createNewCssFileWithFontName:fontName fromOriginal:cssFile inZipFile:zipFileWrite];
            [newFontFilePathsArray addObject:newCSSFileNameInZip];
        }

        // Delete temporary file.
        [cssFile deleteTemporaryFile];

        // Store information about the original and duplicated css file paths.
        fontSupportDictionary[cssFile.epubCSSFilePath] = newFontFilePathsArray;
    }

    // Write information regarding the css files from epub in the epub's root folder.
    // The existance of this file will mean that we added font support for an epub.
    OZZipWriteStream *writeStream = [zipFileWrite writeFileInZipWithName:kFontSupportFileName compressionLevel:OZZipCompressionLevelDefault error:nil];
    _fontSupportFile = [BIFontSupportFile fontSupportFromDictionary:fontSupportDictionary toWriteStream:writeStream];
    [writeStream finishedWriting:nil];

    [zipFileWrite close:nil];

    return _fontSupportFile;
}

- (NSString *)createNewCssFileWithFontName:(NSString *)fontName fromOriginal:(BICSSFile *)cssFile inZipFile:(OZZipFile *)zipFileWrite {
    NSString *newFileName = [cssFile zipFilePathForFont:fontName];
    OZZipWriteStream *writeStream = [zipFileWrite writeFileInZipWithName:newFileName compressionLevel:OZZipCompressionLevelDefault error:nil];
    [cssFile writeCSSFileInZipStream:writeStream forFont:fontName];
    [writeStream finishedWriting:nil];
    return newFileName;
}

#pragma mark - Private methods

- (BIFontSupportFile *)fontSupportFileFromZip {
    BIFontSupportFile *fontSupportFileZip = nil;
    OZZipFile *zipFileRead = [[OZZipFile alloc] initWithFileName:self.epubFilePath mode:OZZipFileModeUnzip];

    [zipFileRead goToFirstFileInZip:nil];
    BOOL canContinue = YES;
    do {
        OZFileInZipInfo *currentFileInfo = [zipFileRead getCurrentFileInZipInfo:nil];
        NSString *currentFileName = currentFileInfo.name;
        if ([currentFileName isEqualToString:kFontSupportFileName]) {
            OZZipReadStream *readStream = [zipFileRead readCurrentFileInZip:nil];
            fontSupportFileZip = [BIFontSupportFile fontSupportFileFromReadStream:readStream];
            [readStream finishedReading:nil];
            break;
        }
        canContinue = [zipFileRead goToNextFileInZip:nil];
    } while (canContinue);

    [zipFileRead close:nil];
    return fontSupportFileZip;
}

- (NSOrderedSet *)duplicateCSSFilesInEPub {
    NSMutableOrderedSet *duplicatedCSSFilesSet = [NSMutableOrderedSet new];
    OZZipFile *zipFileRead = [[OZZipFile alloc] initWithFileName:self.epubFilePath mode:OZZipFileModeUnzip];

    NSUInteger countFilesInZip = [zipFileRead numFilesInZip];
    [zipFileRead goToFirstFileInZip:nil];
    for (NSUInteger currentFileInZipIndex = 0; currentFileInZipIndex < countFilesInZip; currentFileInZipIndex++) {
        OZFileInZipInfo *fileInfo = [zipFileRead getCurrentFileInZipInfo:nil];
        NSString *fileName = fileInfo.name;
        NSString *fileNamePathExtension = [fileName pathExtension];
        if (![fileNamePathExtension isEqualToString:kCSSExtension]) {
            [zipFileRead goToNextFileInZip:nil];
            continue;
        }

        OZZipReadStream *fileReadStream = [zipFileRead readCurrentFileInZip:nil];
        BICSSFile *cssFile = [BICSSFile cssFileFromFileInfo:fileInfo fileZipStreamRead:fileReadStream];
        [cssFile cloneOriginalCSSFile];
        [duplicatedCSSFilesSet addObject:cssFile];
        [zipFileRead goToNextFileInZip:nil];
    }

    return duplicatedCSSFilesSet;
}


@end
