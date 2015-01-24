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

#import "NSArray+ScheduleCalendar.h"


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
    
    NSString *sectionTitle = [self titleForSection:indexPath.section];
    NSArray *contactsAtSection = [self.contactDictionary objectForKey:sectionTitle];
    AddressBookContactObject *contact = contactsAtSection[indexPath.row];
    
    [cell setupCellWithRecord:contact];
    
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
//    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSString *phoneNumber = cell.detailTextLabel.text;
//
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]];
//    [[UIApplication sharedApplication] openURL:url];
    
    NSArray *contactIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *contacts = [NSMutableArray new];
    for (NSIndexPath *indexPath in contactIndexPaths) {
        NSString *sectionTitle = [self titleForSection:indexPath.section];
        NSArray *contactsAtSection = [self.contactDictionary objectForKey:sectionTitle];
        AddressBookContactObject *contact = contactsAtSection[indexPath.row];
        
        [contacts addObject:contact];
    }
    
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
