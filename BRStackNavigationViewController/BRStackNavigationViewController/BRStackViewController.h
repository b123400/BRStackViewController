//
//  BRStackNavigationViewController.h
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRStackViewController : UIViewController{
    NSMutableArray *viewControllers;
    NSMutableArray *containers;
}
@property (strong,nonatomic) NSMutableArray *viewControllers;
@property (strong,nonatomic) NSMutableArray *containers;

-(id)initWithRootViewController:(UIViewController*)rootViewController;

-(void)pushViewController:(UIViewController*)controller;

-(UIViewController*)topViewController;
-(UIViewController*)rootViewController;

@end
