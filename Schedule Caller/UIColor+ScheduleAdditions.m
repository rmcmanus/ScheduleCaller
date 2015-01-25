//
//  UIColor+ScheduleAdditions.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/24/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "UIColor+ScheduleAdditions.h"


static NSString *const ScheduleCalendarGrayCellColor = @"GrayCellColor";
static NSDictionary *ScheduleCalendarColorScheme;


@implementation UIColor (ScheduleAdditions)


#pragma mark - [NSObject Overrides]


+ (void)initialize
{
    if (self == [UIColor class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ScheduleCalendarColorScheme = @{
                ScheduleCalendarGrayCellColor : [self colorWithHex:0xFFF5F5F5]
            };
        });
    }
}


#pragma mark - Class Methods


+ (UIColor *)colorWithScheme:(NSString *)scheme
{
    UIColor *schemeColor = ScheduleCalendarColorScheme[scheme];
    
    return schemeColor ?: [UIColor whiteColor];
}


+ (UIColor *)colorWithHex:(uint32_t)hex
{
    CGFloat alpha = ((hex >> 24) & 0xFF) / 255.0f;
    CGFloat red = ((hex >> 16) & 0xFF) / 255.0f;
    CGFloat green = ((hex >> 8) & 0xFF) / 255.0f;
    CGFloat blue = ((hex) & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (UIColor *)grayCellColor
{
    return [self colorWithScheme:ScheduleCalendarGrayCellColor];
}


@end

