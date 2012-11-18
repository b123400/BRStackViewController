//
//  BRViewController.m
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import "RootViewController.h"
#import "BRStackViewController.h"
#import "UIViewController+Stack.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"hello world %d",indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RootViewController *newViewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        newViewController = [[RootViewController alloc] initWithNibName:@"RootViewController_iPhone" bundle:nil];
    } else {
        newViewController = [[RootViewController alloc] initWithNibName:@"RootViewController_iPad" bundle:nil];
    }
    if(self.parentViewController.childViewControllers.count==1){
        newViewController.view.frame=CGRectInset([self.parentViewController.childViewControllers.lastObject view].frame, 25, 25);
    }else if(self.parentViewController.childViewControllers.count==2){
        newViewController.view.frame=CGRectInset([self.parentViewController.childViewControllers.lastObject view].frame, -10, 0);
    }else{
        newViewController.view.frame=CGRectInset([self.parentViewController.childViewControllers.lastObject view].frame, 60, 40);
    }
    [self.stackViewController pushViewController:newViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
