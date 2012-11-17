//
//  BRAppDelegate.h
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRStackViewController.h"

@class RootViewController;

@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BRStackViewController *viewController;

@end
