//
//  BIFileHelpers.h
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

@import Foundation;

/**
 * Helper class for file related operations.
 */
@interface BIFileHelpers : NSObject

+ (NSString *)generateUniqueFilepathForFile:(NSString *)fileName;

+ (void)deleteFile:(NSString *)filepath;

@end
