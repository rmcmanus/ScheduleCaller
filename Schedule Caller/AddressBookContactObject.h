//
//  AddressBookContactObject.h
//  Schedule Caller
//
//  Created by Ryan McManus on 1/18/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@import AddressBook;


@interface AddressBookContactObject : NSObject

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@property (nonatomic, copy) NSString *phoneNumber;

- (id)initWithReferenceRecord:(ABRecordRef)recordReference;

@end
