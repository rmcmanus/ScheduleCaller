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
    NSString *stringlessNumber = [originalNumber stringByReplacingOccurrencesOfString:@"\\D"
                                                                     withString:@""
                                                                        options:NSRegularExpressionSearch
                                                                          range:NSMakeRange(0, originalNumber.length)];
    NSMutableString *formattedNumber = [NSMutableString string];
    
    NSInteger numberLength = stringlessNumber.length;
    
    NSUInteger index = 0;
    
    if ([self hasInternationalOneInNumber:stringlessNumber atIndex:index]) {
        [formattedNumber appendString:@"1-"];
        index++;
    }
    else if ([self hasLeadingPlusInNumber:stringlessNumber]) {
        [formattedNumber appendString:@"+"];
        index++;
        
        if ([self hasInternationalOneInNumber:stringlessNumber atIndex:index]) {
            [formattedNumber appendString:@"1-"];
            index++;
        }
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
