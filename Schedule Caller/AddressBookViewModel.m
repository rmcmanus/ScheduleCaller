//
//  AddressBookViewModel.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookViewModel.h"


@implementation AddressBookViewModel


#pragma mark - Public


- (NSInteger)checkAccessOnAddressBook
{
    CFErrorRef error = NULL;
    self.addressBookReference = ABAddressBookCreateWithOptions(NULL, &error);
    
    NSInteger accessType = -1;
    
    switch (ABAddressBookGetAuthorizationStatus()) {
        case  kABAuthorizationStatusAuthorized:
            self.objects = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBookReference, nil, kABPersonSortByLastName);
            accessType = AddressBookAccessSucceess;
            
            break;
        case  kABAuthorizationStatusNotDetermined:
            [self requestAddressBookAccess];
            
            break;
        case  kABAuthorizationStatusDenied:
            accessType = AddressBookAccessDenied;
            
            break;
        case  kABAuthorizationStatusRestricted:
            accessType = AddressBookAccessRestricted;
            
            break;
        default:
            break;
    }
    
    return accessType;
}


- (NSString *)formatPhoneNumber:(NSString *)originalNumber
{
    NSMutableString *formattedNumber = [NSMutableString string];
    
    NSInteger numberLength = originalNumber.length;
    
    NSUInteger index = 0;
    
    if ([self hasInternationalOneInNumber:originalNumber atIndex:index]) {
        [formattedNumber appendString:@"1-"];
        index++;
    }
    else if ([self hasLeadingPlusInNumber:originalNumber]) {
        [formattedNumber appendString:@"+"];
        index++;
        
        if ([self hasInternationalOneInNumber:originalNumber atIndex:index]) {
            [formattedNumber appendString:@"1-"];
            index++;
        }
    }
    
    while (index < (numberLength - 4)) {
        NSString *areaCode = [originalNumber substringWithRange:NSMakeRange(index, 3)];
        [formattedNumber appendFormat:@"%@-",areaCode];
        index += 3;
    }
    
    NSString *remainder = [originalNumber substringFromIndex:index];
    [formattedNumber appendString:remainder];
    
    return formattedNumber;
}


#pragma mark - Private


- (void)requestAddressBookAccess
{
    ABAddressBookRequestAccessWithCompletion(self.addressBookReference, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    });
}


- (BOOL)hasInternationalOneInNumber:(NSString *)originalNumber atIndex:(NSInteger)index
{
    return [originalNumber characterAtIndex:index] == '1';
}


- (BOOL)hasLeadingPlusInNumber:(NSString *)originalNumber
{
    return [originalNumber characterAtIndex:0] == '+';
}


@end
