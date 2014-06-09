//
//  BIFilesTableViewCell.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "BIEPubFontLib.h"

#import "BIFilesTableViewCell.h"
#import "NSBundle+FullPath.h"

@implementation BIFilesTableViewCell


#pragma mark - Property

- (void)setFile:(NSString *)file {
    if ([_file isEqualToString:file]) {
        return;
    }
    _file = [file copy];
    self.textLabel.text = file;
}

@end
