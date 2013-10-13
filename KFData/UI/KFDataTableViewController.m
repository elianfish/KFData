//
//  KFDataTableViewController.m
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "KFDataTableViewController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFDataStore.h"
#import "KFDataTableViewDataSource.h"

@interface KFDataTableViewDataSourceController : KFDataTableViewDataSource

@end

@implementation KFDataTableViewDataSourceController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [(KFDataTableViewController *)[tableView delegate] tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

@interface KFDataTableViewController ()

@end

@implementation KFDataTableViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSError *error;
    if ([self dataSource] && ([self performFetch:&error] == NO)) {
        NSLog(@"KFDataTableViewController: Error performing fetch %@", error);
    }
}

#pragma mark -

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    _dataSource = [[KFDataTableViewDataSourceController alloc] initWithTableView:[self tableView] managedObjectContext:managedObjectContext fetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];

    if ([self isViewLoaded]) {
        NSError *error;
        if ([self performFetch:&error] == NO) {
            NSLog(@"KFDataTableViewController: Error performing fetch %@", error);
        }
    }
}

- (void)setObjectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    _dataSource = [[KFDataTableViewDataSourceController alloc] initWithTableView:[self tableView] objectManager:objectManager sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];

    if ([self isViewLoaded]) {
        NSError *error;
        if ([self performFetch:&error] == NO) {
            NSLog(@"KFDataTableViewController: Error performing fetch %@", error);
        }
    }
}

- (BOOL)performFetch:(NSError **)error {
    return [_dataSource performFetch:error];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *managedObject = [(KFDataTableViewDataSource *)[tableView dataSource] objectAtIndexPath:indexPath];
    return [self tableView:tableView cellForManagedObject:managedObject atIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath {
    NSString *reason = [NSStringFromClass([self class]) stringByAppendingString:@": You must override tableView:cellForManagedObject:atIndexPath:"];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end

#endif
