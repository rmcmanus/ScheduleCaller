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


- (void)setupCellWithViewModel:(AddressBookViewModel *)viewModel indexPath:(NSIndexPath *)indexPath
{
    ABRecordRef recordReference = (__bridge ABRecordRef)viewModel.objects[indexPath.row];
    NSString *name = (__bridge_transfer  NSString*)ABRecordCopyCompositeName(recordReference);
    self.textLabel.text = name;
    
    NSString *phoneNumber = @" ";
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(recordReference, kABPersonPhoneProperty);
    if(ABMultiValueGetCount(phoneNumbers) > 0){
        phoneNumber = [(__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0) formatPhoneNumber];
    }
    
    self.detailTextLabel.text = phoneNumber;
}


@end
