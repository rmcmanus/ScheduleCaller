//
//  NSString+ScheduleAdditions.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "NSString+ScheduleAdditions.h"

@implementation NSString (ScheduleAdditions)


#pragma mark - Public


- (NSString *)formatPhoneNumber
{
    NSString *stringlessNumber = [self stringByReplacingOccurrencesOfString:@"\\D"
                                                                 withString:@""
                                                                    options:NSRegularExpressionSearch
                                                                      range:NSMakeRange(0, self.length)];
    NSMutableString *formattedNumber = [NSMutableString string];
    
    NSInteger numberLength = stringlessNumber.length;
    NSUInteger index = 0;
    
    if ([self hasInternationalOneAtIndex:index] || [self hasLeadingPlus]) {
        [formattedNumber appendString:@"1-"];
        index++;
    }
    
    while (index < (numberLength - 4)) {
        if ([stringlessNumber characterAtIndex:index] == '(' || [stringlessNumber characterAtIndex:index] == ')') {
            index++;
            continue;
        }
        NSString *areaCode = [stringlessNumber substringWithRange:NSMakeRange(index, 3)];
        [formattedNumber appendFormat:@"%@-",areaCode];
        index += 3;
    }
    
    NSString *remainder = [stringlessNumber substringFromIndex:index];
    [formattedNumber appendString:remainder];
    
    return formattedNumber;
}


#pragma mark - Private


- (BOOL)hasInternationalOneAtIndex:(NSInteger)index
{
    return [self characterAtIndex:index] == '1';
}


- (BOOL)hasLeadingPlus
{
    return [self characterAtIndex:0] == '+';
}


@end
