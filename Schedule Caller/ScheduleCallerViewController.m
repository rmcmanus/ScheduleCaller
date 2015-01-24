//
//  ScheduleCallerViewController.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/23/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "ScheduleCallerViewController.h"

#import "AddressBookViewController.h"
#import "AddressBookContactObject.h"


static NSString *const ScheduleCallerContactReuseIdentifier = @"scheduleCallerReuseIdentifier";
static NSString *const ScheduleCallerContactsNavigationSegueIdentifier = @"ContactsNavigationSegueIdentifier";


@interface ScheduleCallerViewController () <UITableViewDataSource, UITableViewDelegate, AddressBookDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AddressBookViewController *contactsViewController;
@property (nonatomic, strong) NSMutableArray *contactsArray;

@end


@implementation ScheduleCallerViewController


#pragma mark - Setup & Teardown


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contactsArray = [NSMutableArray new];
    }
    
    return self;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:ScheduleCallerContactsNavigationSegueIdentifier]) {
        UINavigationController *addressBookNavigationController = (UINavigationController *)segue.destinationViewController;
        self.contactsViewController = (AddressBookViewController *)(addressBookNavigationController.viewControllers[0]);
        self.contactsViewController.delegate = self;
    }
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.contactsArray count];
    
    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScheduleCallerContactReuseIdentifier];
    
    return cell;
}


#pragma mark - <AddressBookDelegate>


- (void)addressBook:(AddressBookViewController *)viewController didSelectContacts:(NSArray *)contacts
{
    for (AddressBookContactObject *contact in contacts) {
        [self.contactsArray addObject:contact];
    }
    
    [self.tableView reloadData];
}


@end
