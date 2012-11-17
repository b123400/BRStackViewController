//
//  UIViewController+Stack.h
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Stack)

-(BRStackViewController*)stackViewController;
-(void)setStackViewController:(BRStackViewController*)stackViewController;

@end
