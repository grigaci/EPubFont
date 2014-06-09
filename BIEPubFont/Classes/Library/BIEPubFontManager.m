//
//  BIEPubFontManager.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 6/9/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "BIEPubFontManager.h"

@implementation BIEPubFontManager

+ (instancetype)sharedInstance {
    static id sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        <#code to be executed once#>
    });
}
@end
