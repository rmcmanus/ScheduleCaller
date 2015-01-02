//
//  ViewController.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/1/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "AddressBookViewController.h"

@import AddressBook;


static NSString *callerCellIdentifier = @"callerIdentifier";


@interface AddressBookViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *objects;
@property (nonatomic) ABAddressBookRef addressBookReference;


@end


@implementation AddressBookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFErrorRef error = NULL;
    self.addressBookReference = ABAddressBookCreateWithOptions(NULL, &error);
    
    [self checkAccessOnAddressBook];
}


#pragma mark - Private


- (void)checkAccessOnAddressBook
{
    switch (ABAddressBookGetAuthorizationStatus()) {
        case  kABAuthorizationStatusAuthorized:
            self.objects = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBookReference, nil, kABPersonSortByLastName);
            [self.tableView reloadData];
            
            break;
        case  kABAuthorizationStatusNotDetermined:
            [self requestAddressBookAccess];
            
            break;
        case  kABAuthorizationStatusDenied: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts. Please grant permission by going to \nSettings->Privacy->Contacts and enabling Whozoo to access your contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
            
            break;
        case  kABAuthorizationStatusRestricted: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            
            break;
        default:
            break;
    }
}


- (void)requestAddressBookAccess
{
    ABAddressBookRequestAccessWithCompletion(self.addressBookReference, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{    
            });
        }
    });
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:callerCellIdentifier];
    
    ABRecordRef recordReference = (__bridge ABRecordRef)self.objects[indexPath.row];
    cell.textLabel.text = (__bridge_transfer  NSString*)ABRecordCopyCompositeName(recordReference);
    
    NSString *phoneNumber = @"";
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(recordReference, kABPersonPhoneProperty);
    if(ABMultiValueGetCount(phoneNumbers) > 0){
        phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    cell.detailTextLabel.text = phoneNumber;
    
    return cell;
}


#pragma mark - <UITableViewDelegate>


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
