//
//  ViewController.h
//  Schedule Caller
//
//  Created by Ryan McManus on 1/1/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressBookContactObject;


@protocol AddressBookDelegate;


@interface AddressBookViewController : UIViewController

@property (nonatomic, weak) id<AddressBookDelegate> delegate;

@end


@protocol AddressBookDelegate <NSObject>

- (void)addressBook:(AddressBookViewController *)viewController didSelectContact:(AddressBookContactObject *)contact;

@end

