//
//  AddressBookViewModel.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookViewModel.h"

#import "AddressBookContactObject.h"
#import "NSArray+ScheduleCalendar.h"


@interface AddressBookViewModel ()

@property (nonatomic, strong) NSMutableDictionary *contactDictionary;

@end


@implementation AddressBookViewModel


#pragma mark - Setup & Teardown


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contactDictionary = [NSMutableDictionary new];
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
            [self setupContactsDictionary];
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
        completionBlock(self.contactDictionary, accessType, nil);
    }
}


#pragma mark - Private


- (void)setupContactsDictionary
{
    NSArray *referenceArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBookReference, nil, kABPersonSortByLastName);
    NSMutableArray *contactArray = [NSMutableArray new];
    
    for (id reference in referenceArray) {
        ABRecordRef recordReference = (__bridge ABRecordRef)reference;
        AddressBookContactObject *contact = [[AddressBookContactObject alloc] initWithReferenceRecord:recordReference];
        
        [contactArray addObject:contact];
    }
    
    [[NSArray alphabetArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = (NSString *)obj;
        NSArray *titleArray = [self contactsAtSection:idx title:title array:contactArray];
        
        [self.contactDictionary setObject:titleArray forKey:title];
    }];
}


- (NSArray *)contactsAtSection:(NSInteger)section title:(NSString *)title array:(NSArray *)contactArray
{
    NSMutableArray *arrayForTitle = [NSMutableArray new];
    
    for (AddressBookContactObject *contact in contactArray) {
        if (contact.lastName == nil) {
            continue;
        }
        
        NSString *lastNameLetter = [contact.lastName substringWithRange:NSMakeRange(0, 1)];
        if ([lastNameLetter isEqualToString:title]) {
            [arrayForTitle addObject:contact];
        }
    }
    
    return arrayForTitle;
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
