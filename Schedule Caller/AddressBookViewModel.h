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
    AddressBookAccessSucceess = 0,
    AddressBookAccessDenied,
    AddressBookAccessRestricted
};


@interface AddressBookViewModel : NSObject


@property (nonatomic, copy) NSMutableArray *objects;
@property (nonatomic) ABAddressBookRef addressBookReference;


- (NSInteger)checkAccessOnAddressBook;


@end
