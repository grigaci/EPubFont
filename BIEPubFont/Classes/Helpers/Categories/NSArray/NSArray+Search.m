//
//  NSArray+Search.m
//  BIEPubFont
//
//  Created by bogdan on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "NSArray+Search.h"

@implementation NSArray (Search)

- (BOOL)containsString:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[cd] %@", string];
    NSArray *filtered = [self filteredArrayUsingPredicate:predicate];
    return [filtered count];
}

@end
