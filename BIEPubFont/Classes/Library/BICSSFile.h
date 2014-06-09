//
//  BICSSFile.h
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

@import Foundation;

@class OZFileInZipInfo;
@class OZZipReadStream;
@class OZZipWriteStream;


/**
 * Helper class.
 * You should not create instances of this class.
 */
@interface BICSSFile : NSObject

// Don't allow to create instances using init or new.
- NS_UNAVAILABLE init;
+ NS_UNAVAILABLE new;

+ (instancetype)cssFileFromFileInfo:(OZFileInZipInfo *)existingFileInfo
                  fileZipStreamRead:(OZZipReadStream *)existingZipStream;

- (instancetype)initWithCSSFileFromFileInfo:(OZFileInZipInfo *)existingFileInfo
                          fileZipStreamRead:(OZZipReadStream *)existingZipStream;

// Path to the original css file inside zipped epub.
@property (nonatomic, copy, readonly) NSString *epubCSSFilePath;

// Path to the temporary file from Cache folder.
@property (nonatomic, copy, readonly) NSString *temporaryFilePath;

/**
 * Get file path for a new css file for a given font name.
 * For example, if original file is EPUB/css/epub.css and fontName is Arial it will return EPUB/css/epub-Arial.css.
 */
- (NSString *)zipFilePathForFont:(NSString *)fontName;

/**
 * Copies file from epubCSSFilePath to temporaryFilePath.
 */
- (void)cloneOriginalCSSFile;

/**
 * Parses content from temporaryFilePath. Any occurrence of a specific font will be replaced with fontName.
 * Output is written in writeStream.
 */
- (void)writeCSSFileInZipStream:(OZZipWriteStream *)writeStream
                        forFont:(NSString *)fontName;

// Deletes temporaryFilePath from Cache folder.
- (void)deleteTemporaryFile;

@end
