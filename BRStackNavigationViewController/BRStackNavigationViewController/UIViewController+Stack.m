//
//  UIViewController+Stack.m
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//
#import <objc/runtime.h>
#import "BRStackViewController.h"
#import "UIViewController+Stack.h"

static char STACK_VIEW_CONTROLLER_KEY;

@implementation UIViewController (Stack)

-(BRStackViewController*)stackViewController{
    return (BRStackViewController*) objc_getAssociatedObject(self, &STACK_VIEW_CONTROLLER_KEY);
}
-(void)setStackViewController:(BRStackViewController*)stackViewController{
	objc_setAssociatedObject(self, &STACK_VIEW_CONTROLLER_KEY, stackViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
