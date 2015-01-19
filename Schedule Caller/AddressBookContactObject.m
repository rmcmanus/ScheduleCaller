//
//  AddressBookContactObject.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/18/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookContactObject.h"

#import "NSString+ScheduleAdditions.h"


@implementation AddressBookContactObject


#pragma mark - Setup & Teardown


- (id)initWithReferenceRecord:(ABRecordRef)recordReference
{
    self = [super init];
    if (self) {
        [self buildContactObjectFromReferenceRecord:recordReference];
    }
    
    return self;
}


#pragma mark - Private


- (void)buildContactObjectFromReferenceRecord:(ABRecordRef)recordReference
{
    NSString *name = (__bridge_transfer  NSString*)ABRecordCopyCompositeName(recordReference);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(recordReference, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(recordReference
                                                      , kABPersonLastNameProperty);
    
    NSString *phoneNumber = @" ";
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(recordReference, kABPersonPhoneProperty);
    if(ABMultiValueGetCount(phoneNumbers) > 0){
        phoneNumber = [(__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0) formatPhoneNumber];
    }
    
    self.firstName = firstName;
    self.lastName = lastName;
    self.fullName = name;
    
    self.phoneNumber = phoneNumber;
}


@end
