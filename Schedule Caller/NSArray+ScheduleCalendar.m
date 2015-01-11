//
//  NSArray+ScheduleCalendar.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/11/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "NSArray+ScheduleCalendar.h"

@implementation NSArray (ScheduleCalendar)


+ (NSArray *)alphabetArray
{
    NSArray *alphabet = [NSArray arrayWithArray:[@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,#" componentsSeparatedByString:@","]];
    
    return alphabet;
}


@end
