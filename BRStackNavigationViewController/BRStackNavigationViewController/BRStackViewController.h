//
//  BRStackNavigationViewController.h
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRStackViewController : UIViewController{
    NSMutableArray *containers;
    BOOL isPushing;
    BOOL isPopping;
    
    UIView *panningView;
}
@property (strong,nonatomic) NSMutableArray *containers;

-(id)initWithRootViewController:(UIViewController*)rootViewController;

-(void)pushViewController:(UIViewController*)controller;

-(UIViewController*)topViewController;
-(UIViewController*)rootViewController;
-(void)layoutWithPopProgress:(float)popProgress completion:(void (^)(BOOL finished))completion animated:(BOOL)animated;

#pragma mark UINavigationViewController compatible

-(NSArray*)viewControllers;

@end
