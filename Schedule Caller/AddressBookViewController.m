//
//  ViewController.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/1/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookViewController.h"

#import "AddressBookViewModel.h"
#import "AddressBookContactObject.h"
#import "AddressBookDetailTableViewCell.h"

#import "NSArray+ScheduleAdditions.h"


@import AddressBook;


static NSString *callerCellIdentifier = @"callerIdentifier";


@interface AddressBookViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *contactDictionary;
@property (nonatomic, strong) AddressBookViewModel *addressBookViewModel;


@end


@implementation AddressBookViewController


#pragma mark - Setup & Teardown


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.addressBookViewModel = [[AddressBookViewModel alloc] init];
    }
    
    return self;
}


#pragma mark - UIViewController overrides


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.addressBookViewModel checkAccessOnAddressBookWithCompletionBlock:^(NSDictionary *contactDictionary, enum AddressBookAccess accessType, NSError *error) {
        if (accessType == AddressBookAccessSucceess) {
            self.contactDictionary = contactDictionary;
            [self.tableView reloadData];
        }
        else if (accessType == AddressBookAccessDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts. Please grant permission by going to \nSettings->Privacy->Contacts and enabling Schedule Calling to access your contacts."
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
    }];
}


#pragma mark - Private


- (NSString *)titleForSection:(NSInteger)section
{
    return [[NSArray alphabetArray] objectAtIndex:section];
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [[NSArray alphabetArray] objectAtIndex:section];
    NSArray *alphabetCount = [self.contactDictionary objectForKey:sectionTitle];
    
    return [alphabetCount count];
}


- (AddressBookContactObject *)contactForIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [self titleForSection:indexPath.section];
    NSArray *contactsAtSection = [self.contactDictionary objectForKey:sectionTitle];
    AddressBookContactObject *contact = contactsAtSection[indexPath.row];
    
    return contact;
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger alphabetCount = [[NSArray alphabetArray] count];
    
    return alphabetCount;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self numberOfRowsInSection:section] == 0) {
        return nil;
    }
    
    NSString *title = [self titleForSection:section];
    
    return title;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self numberOfRowsInSection:section];
    
    return rowCount;
}


- (AddressBookDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:callerCellIdentifier];
    
    AddressBookContactObject *contact = [self contactForIndexPath:indexPath];
    [cell setupCellWithRecord:contact];
    
    for (AddressBookContactObject *selectedContact in self.selectedContacts) {
        if ([selectedContact.fullName isEqualToString:contact.fullName]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
    }
    
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *alphabetSectionIndexes = [NSArray alphabetArray];
    
    return alphabetSectionIndexes;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSArray *alphabetArray = [NSArray alphabetArray];
    
    return [alphabetArray indexOfObject:title];
}


#pragma mark - <UITableViewDelegate>


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}


#pragma mark - Actions


- (IBAction)sendSelectedCellsToCallerView:(id)sender
{    
    NSArray *contactIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *contacts = [NSMutableArray new];
    
    for (NSIndexPath *indexPath in contactIndexPaths) {
        [contacts addObject:[self contactForIndexPath:indexPath]];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    [contacts sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    if ([self.delegate respondsToSelector:@selector(addressBook:didSelectContacts:)]) {
        [self.delegate addressBook:self didSelectContacts:contacts];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)dismissContactSelector:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
