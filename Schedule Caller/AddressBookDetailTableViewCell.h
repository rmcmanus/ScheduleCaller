//
//  AddressBookDetailTableViewCell.h
//  Schedule Caller
//
//  Created by Ryan McManus on 1/2/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressBookContactObject.h"


@interface AddressBookDetailTableViewCell : UITableViewCell

- (void)setupCellWithRecord:(AddressBookContactObject *)contact;

@end
