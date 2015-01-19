//
//  AddressBookDetailTableViewCell.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookDetailTableViewCell.h"

#import "NSString+ScheduleAdditions.h"


@implementation AddressBookDetailTableViewCell


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
}


- (void)setupCellWithRecord:(AddressBookContactObject *)contact indexPath:(NSIndexPath *)indexPath
{
    NSString *name = contact.fullName;
    self.textLabel.text = name;
    
    NSString *phoneNumber = contact.phoneNumber;
    self.detailTextLabel.text = phoneNumber;
}


@end
