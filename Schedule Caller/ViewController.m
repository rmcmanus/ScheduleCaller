//
//  ViewController.m
//  Schedule Caller
//
//  Created by Ryan McManus on 1/1/15.
//  Copyright (c) 2015 Ryan McManus. All rights reserved.
//

#import "ViewController.h"

@import AddressBook;


static NSString *callerCellIdentifier = @"callerIdentifier";


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic) ABAddressBookRef addressBookReference;
@property (nonatomic) CFArrayRef allPeople;
@property (nonatomic) CFIndex numberOfPeople;

@property (nonatomic, copy) NSArray *sortedNames;
@property (nonatomic, copy) NSArray *sortedNumbers;


@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFErrorRef error = NULL;
    self.addressBookReference = ABAddressBookCreateWithOptions(NULL, &error);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ABAddressBookRequestAccessWithCompletion(self.addressBookReference, ^(bool granted, CFErrorRef error) {
        if (granted) {
            [self accessContacts];
            
            [self.tableView reloadData];
        }
    });
}


#pragma mark - Private


- (void)accessContacts
{
    self.allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBookReference, nil, kABPersonSortByLastName);
    self.numberOfPeople = ABAddressBookGetPersonCount(self.addressBookReference);
    
    NSDictionary *contactDictionary = [self createContactDictionary];
    
    NSArray *sortedKeys = [[contactDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        [sortedValues addObject: [contactDictionary objectForKey: key]];
    }
    
    self.sortedNames = sortedKeys;
    self.sortedNumbers = sortedValues;
}


- (NSDictionary *)createContactDictionary
{
    NSMutableDictionary *contactDictionary = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(self.allPeople, i);
        
        NSString *firstName = [self contact:person firstNameAtIndex:i];
        NSString *lastName = [self contact:person lastNameAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        NSArray *phoneNumbers = [self contact:person phoneNumberAtIndex:i];
        NSString *phoneNumber = @"";
        if (phoneNumbers && [phoneNumbers count] > 0) {
            phoneNumber = [phoneNumbers objectAtIndex:0];
        }
        
        [contactDictionary setObject:phoneNumber forKey:name];
    }
    
    return contactDictionary;
}


- (NSString *)contact:(ABRecordRef)person firstNameAtIndex:(int)index
{
    NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    
    return firstName;
}


- (NSString *)contact:(ABRecordRef)person lastNameAtIndex:(int)index
{
    NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    return lastName;
}


- (NSArray *)contact:(ABRecordRef)person phoneNumberAtIndex:(int)index
{
    NSMutableArray *phoneNumbersArray = [NSMutableArray array];
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
        NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        [phoneNumbersArray addObject:phoneNumber];
    }
    
    return phoneNumbersArray;
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CFArrayGetCount(self.allPeople);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:callerCellIdentifier];
    
    cell.textLabel.text = [self.sortedNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.sortedNumbers objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
