//
//  ViewController.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/1/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookViewController.h"

#import "AddressBookViewModel.h"
#import "AddressBookDetailTableViewCell.h"


@import AddressBook;


static NSString *callerCellIdentifier = @"callerIdentifier";


@interface AddressBookViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AddressBookViewModel *addressBookViewModel;


@end


@implementation AddressBookViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.addressBookViewModel = [[AddressBookViewModel alloc] init];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger accessType = [self.addressBookViewModel checkAccessOnAddressBook];
    
    if (accessType == AddressBookAccessSucceess) {
        [self.tableView reloadData];
    }
    else if (accessType == AddressBookAccessDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                        message:@"Permission was not granted for Contacts. Please grant permission by going to \nSettings->Privacy->Contacts and enabling Whozoo to access your contacts."
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (accessType == AddressBookAccessRestricted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                        message:@"Permission was not granted for Contacts."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressBookViewModel.objects.count;
}


- (AddressBookDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:callerCellIdentifier];
    
    [cell setupCellWithViewModel:self.addressBookViewModel indexPath:indexPath];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
