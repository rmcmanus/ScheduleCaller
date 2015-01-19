//
//  AddressBookViewModel.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookViewModel.h"

#import "AddressBookContactObject.h"


@interface AddressBookViewModel ()

@property (nonatomic, strong) NSMutableArray *contactBook;

@end


@implementation AddressBookViewModel


#pragma mark - Setup & Teardown


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contactBook = [NSMutableArray new];
    }
    
    return self;
}


#pragma mark - Public


- (void)checkAccessOnAddressBookWithCompletionBlock:(AddressBookViewModelCompletionHandler)completionBlock
{
    CFErrorRef error = NULL;
    self.addressBookReference = ABAddressBookCreateWithOptions(NULL, &error);
    
    NSInteger accessType = AddressBookAccessNull;
    
    switch (ABAddressBookGetAuthorizationStatus()) {
        case  kABAuthorizationStatusAuthorized:
            [self setupContactsArray];
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
    
    if (accessType != AddressBookAccessNull) {
        completionBlock(self.contactBook, accessType, nil);
    }
}


#pragma mark - Private


- (void)setupContactsArray
{
    NSArray *array = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBookReference, nil, kABPersonSortByLastName);
    
    for (id reference in array) {
        ABRecordRef recordReference = (__bridge ABRecordRef)reference;
        AddressBookContactObject *contact = [[AddressBookContactObject alloc] initWithReferenceRecord:recordReference];
        
        [self.contactBook addObject:contact];
    }
}


- (void)requestAddressBookAccess
{
    ABAddressBookRequestAccessWithCompletion(self.addressBookReference, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    });
}


@end
