//
//  NSString+CSSFile.m
//  BIEPubFont
//
//  Created by bogdan on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "NSString+CSSFile.h"

@implementation NSString (CSSFile)

NSString * kCSSFileExtenstionString = @"css";

- (BOOL)isCSSFile {
    NSString *extension = [self pathExtension];
    return [extension isEqualToString:kCSSFileExtenstionString];
}

@end
