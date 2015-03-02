//
//  JDFViewController.m
//  JDFPeekaboo
//
//  Created by Joe Fryer on 02/01/2015.
//  Copyright (c) 2014 Joe Fryer. All rights reserved.
//

#import "JDFViewController.h"

// Peekaboo
#import "JDFPeekabooCoordinator.h"

// View Controllers
#import "JDFDetailViewController.h"


static NSString *const JDFSampleViewControllerCellIdentifier = @"JDFSampleViewControllerCellIdentifier";


@interface JDFViewController ()

@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

@end


@implementation JDFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *blueColour = [UIColor colorWithRed:44.0f/255.0f green:62.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBar.barTintColor = blueColour;
    self.navigationController.toolbar.barTintColor = blueColour;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.tableView;
    self.scrollCoordinator.topView = self.navigationController.navigationBar;
    self.scrollCoordinator.topViewMinimisedHeight = 20.0f;
    self.scrollCoordinator.bottomView = self.navigationController.toolbar;
    
    self.navigationItem.title = @"Peekaboo";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JDFSampleViewControllerCellIdentifier];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem = doneButton;

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchButton setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchBarButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.scrollCoordinator disable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.scrollCoordinator enable];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JDFSampleViewControllerCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDFDetailViewController *detailViewController = [[JDFDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
