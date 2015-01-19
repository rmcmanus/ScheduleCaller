//
//  AddressBookViewModel.h
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AddressBook;


NS_ENUM(NSInteger, AddressBookAccess) {
    AddressBookAccessNull = -1,
    AddressBookAccessSucceess = 0,
    AddressBookAccessDenied,
    AddressBookAccessRestricted
};


typedef void (^AddressBookViewModelCompletionHandler)(NSDictionary *contactDictionary, enum AddressBookAccess accessType, NSError *error);


@interface AddressBookViewModel : NSObject

@property (nonatomic) ABAddressBookRef addressBookReference;


- (void)checkAccessOnAddressBookWithCompletionBlock:(AddressBookViewModelCompletionHandler)completion;

@end
