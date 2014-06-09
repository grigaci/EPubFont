//
//  BIEPubFile.h
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

@import Foundation;

@class BIFontSupportFile;

/**
 * Represents an epub file.
 * Use this class if you want your epub file to have a specific font.
 * Example:
 * If you look inside accessible_epub_3-20121024.epub file( https://code.google.com/p/epub-samples/downloads/detail?name=accessible_epub_3-20121024.epub&can=2&q= )
 * you will see that it contains two css files: EPUB/css/epub.css and EPUB/css/synth.css .
 * Calling createFontSupportFileForFonts method with only @"Arial" string in the set will create
 * two more files: EPUB/css/epub-Arial.css and EPUB/css/synth-Arial.css. Any occurrences of
 * specific font from original files was replaced with Arial.
 *
 * If you render the epub after the above modifications you will see no changes because the epub still use the original
 * css files. If you want the custom font set by you earlier your will have to specify to the render engine to load
 * one of the newly created css files.
 * Tested this approach with Readium( https://github.com/readium/SDKLauncher-iOS ) on EPub 2 and EPub 3 files.
 */
@interface BIEPubFile : NSObject

// Don't allow to create instances using init or new.
- NS_UNAVAILABLE init;
+ NS_UNAVAILABLE new;

/**
 * Create an instance giving a full path to an epub file.
 * @param path Full path to an epub file.
 */
+ (instancetype)epubFileAtPath:(NSString *)path;

/**
 * Get the font support file stored inside the epub file.
 * Returns nill if the epub does not contain such file.
 */
@property (nonatomic, strong, readonly) BIFontSupportFile *fontSupportFile;

/**
 * Check if the epub file contains the font support file.
 */
- (BOOL)doesEPubContainFontSupportFile;

/**
 * Create font support file for this epub.
 * Will duplicate all .css file from epub and replace each occurrence of font-family with onde the specified fonts.
 * @param fonts Set of NSString type objects representing the font names, e.g. Arial, Calibri etc
 */
- (BIFontSupportFile *)createFontSupportFileForFonts:(NSOrderedSet *)fonts;

@end
