//
//  ScheduleCallerViewController.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/23/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "ScheduleCallerViewController.h"
#import "ScheduleCallerDetailTableViewCell.h"

#import "AddressBookViewController.h"
#import "AddressBookContactObject.h"

#import "UIColor+ScheduleAdditions.h"


static NSString *const ScheduleCallerContactReuseIdentifier = @"scheduleCallerReuseIdentifier";
static NSString *const ScheduleCallerContactsNavigationSegueIdentifier = @"ContactsNavigationSegueIdentifier";


@interface ScheduleCallerViewController () <UITableViewDataSource, UITableViewDelegate, AddressBookDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *emptyDataView;

@property (nonatomic, strong) AddressBookViewController *contactsViewController;
@property (nonatomic, strong) NSMutableArray *contactsArray;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL isSelected;

@end


@implementation ScheduleCallerViewController


#pragma mark - Setup & Teardown


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contactsArray = [NSMutableArray new];
        
        self.selectedIndex = -1;
        self.isSelected = NO;
    }
    
    return self;
}


#pragma mark - [UIViewController Overrides]


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emptyDataView.hidden = NO;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:ScheduleCallerContactsNavigationSegueIdentifier]) {
        UINavigationController *addressBookNavigationController = (UINavigationController *)segue.destinationViewController;
        self.contactsViewController = (AddressBookViewController *)(addressBookNavigationController.viewControllers[0]);
        self.contactsViewController.delegate = self;
        self.contactsViewController.selectedContacts = self.contactsArray;
    }
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.contactsArray count];
    
    return rowCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL thisIndex = self.selectedIndex == indexPath.row;
    BOOL indexSelected = thisIndex && self.isSelected;
    
    if (indexSelected) {
        return 80.0f;
    }
    
    return 45.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCallerDetailTableViewCell *cell = (ScheduleCallerDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScheduleCallerContactReuseIdentifier];
    
    cell.contact = self.contactsArray[indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor grayCellColor];
    }
    
    return cell;
}


#pragma mark - <UITableViewDelegate>


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    
    if (self.selectedIndex == indexPath.row) {
        self.selectedIndex = -1;
        self.isSelected = NO;
    }
    else {
        self.selectedIndex = indexPath.row;
        self.isSelected = YES;
    }
    
    [tableView endUpdates];
}


#pragma mark - <AddressBookDelegate>


- (void)addressBook:(AddressBookViewController *)viewController didSelectContacts:(NSArray *)contacts
{
    self.contactsArray = [[NSMutableArray alloc] initWithArray:contacts];
    
    self.emptyDataView.hidden = [self.contactsArray count] > 0;
    
    [self.tableView reloadData];
}


@end
