//
//  BIFontSupportFile.h
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

@import Foundation;

@class OZZipReadStream;
@class OZZipWriteStream;

/**
 * Stores the paths of the duplicated css files in the epub.
 * Do not create instances of this class. BIEpubFile is responsible for this.
 * Use this class if you want to see the paths to newly created css files.
 */
@interface BIFontSupportFile : NSObject

// Don't allow to create instances using init or new.
- NS_UNAVAILABLE init;
+ NS_UNAVAILABLE new;

/**
 * Used when the font support is already implemented.
 * Just read the plist file from zip.
 */
+ (instancetype)fontSupportFileFromReadStream:(OZZipReadStream *)readStream;

/**
 * New font files were just added to the zip file.
 * We have to write the plist file into zip.
 * @param dictionary Pairs of:
 * - key: NSString type object representing the path of the original css file(e.g. EPUB/css/epub.css)
 * - value: NSArray of NSString type objects representing the path of the newly created css files(e.g. EPUB/css/epub-Arial.css).
 * @param writeStream Zip write stream where to put the plist content.
 */
+ (instancetype)fontSupportFromDictionary:(NSDictionary *)dictionary toWriteStream:(OZZipWriteStream *)writeStream;

/**
 * Get all the paths to the original css files within the epub.
 * Returns array of NSString type objects.
 */
- (NSArray *)allOriginalCSSFiles;

/**
 * Get all the paths to the duplicated css files for a given path.
 ( @param pathToOriginaCSSFile Any of the string values returned by allOriginalCSSFiles method.
 * Returns array of NSString type objects.
 */
- (NSArray *)allCustomCSSFilesFor:(NSString *)pathToOriginaCSSFile;

@end
