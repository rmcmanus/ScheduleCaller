//
//  ScheduleCallerDetailTableViewCell.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/24/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "ScheduleCallerDetailTableViewCell.h"

#import "AddressBookContactObject.h"


@interface ScheduleCallerDetailTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *contactNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumberLabel;

@end


@implementation ScheduleCallerDetailTableViewCell


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.contactNameLabel.text = nil;
    self.phoneNumberLabel.text = nil;
}


#pragma mark - Accessors


- (void)setContact:(AddressBookContactObject *)contact
{
    _contact = contact;
    
    self.contactNameLabel.text = contact.fullName;
    self.phoneNumberLabel.text = contact.phoneNumber;
}


#pragma mark - Actions


- (IBAction)callPhoneNumer:(UIButton *)button
{
    NSString *phoneNumber = self.contact.phoneNumber;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}


@end
