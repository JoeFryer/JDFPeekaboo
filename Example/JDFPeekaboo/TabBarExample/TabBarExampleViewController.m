//
//  TabBarExampleViewController.m
//  JDFPeekaboo
//
//  Created by Joe Fryer on 02/03/2015.
//  Copyright (c) 2015 Joe Fryer. All rights reserved.
//

#import "TabBarExampleViewController.h"

// Peekaboo
#import "JDFPeekabooCoordinator.h"

// View Controllers
#import "JDFDetailViewController.h"


static NSString *const JDFSampleViewControllerCellIdentifier = @"JDFSampleViewControllerCellIdentifier";


@interface TabBarExampleViewController ()

// Views
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// Peekaboo
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

@end

@implementation TabBarExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Peekaboo";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    UIColor *blueColour = [UIColor colorWithRed:44.0f/255.0f green:62.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = blueColour;
    self.tabBarController.tabBar.barTintColor = blueColour;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.tableView;
    self.scrollCoordinator.topView = self.navigationController.navigationBar;
    self.scrollCoordinator.bottomView = self.tabBarController.tabBar;
    self.scrollCoordinator.containingView = self.tabBarController.view;
    self.scrollCoordinator.topViewMinimisedHeight = 20.0f;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JDFSampleViewControllerCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scrollCoordinator fullyExpandViews];
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
