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

@property (nonatomic, strong) NSArray *contactBook;
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
    
    [self.addressBookViewModel checkAccessOnAddressBookWithCompletionBlock:^(NSArray *contactBook, enum AddressBookAccess accessType, NSError *error) {
        if (accessType == AddressBookAccessSucceess) {
            self.contactBook = contactBook;
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
    }];
}


#pragma mark - <UITableViewDataSource>


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    NSInteger alphabetCount = [self.addressBookViewModel.objects count];
//    
//    return alphabetCount;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger alphabetCount = [self.contactBook count];
    
    return alphabetCount;
}


- (AddressBookDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:callerCellIdentifier];
    
    AddressBookContactObject *contact = self.contactBook[indexPath.row];
    [cell setupCellWithRecord:contact indexPath:indexPath];
    
    return cell;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSArray *alphabetSectionIndexes = [NSArray alphabetArray];
//    
//    return alphabetSectionIndexes;
//}


//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    
//}


#pragma mark - <UITableViewDelegate>


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDetailTableViewCell *cell = (AddressBookDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *phoneNumber = cell.detailTextLabel.text;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
