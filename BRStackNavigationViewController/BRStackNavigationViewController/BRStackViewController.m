//
//  BRStackNavigationViewController.m
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import "BRStackViewController.h"
#import "UIViewController+Stack.h"
#import "CAAnimation+Blocks.h"

#define NEW_CONTROLLER_SHADOW_WIDTH 20.0f

@interface BRStackViewController ()

@end

@implementation BRStackViewController
@synthesize viewControllers,containers;

-(id)initWithRootViewController:(UIViewController*)rootViewController{
    self=[super init];
    
    self.viewControllers=[NSMutableArray array];
    self.containers=[NSMutableArray array];
    [self.viewControllers addObject:rootViewController];
    rootViewController.stackViewController=self;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[viewControllers.lastObject view]];
    [[viewControllers.lastObject view] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark stack push

-(void)pushViewController:(UIViewController*)controller{
    UIViewController *topController=self.topViewController;
    controller.stackViewController=self;
    [self.viewControllers addObject:controller];
    
    CABasicAnimation *outTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
	outTransform.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.97 :0.15 :1.00 :1.00];
	outTransform.duration=5;
	//outTransform.fromValue= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 0, 0, 0)];
	float f = M_PI/6;
	CATransform3D aTransform = CATransform3DTranslate(CATransform3DMakeRotation(f, 0, 1, 0), 0, 0, 0);
	aTransform.m14 = 1.0 / (4.666667*controller.view.frame.size.width);
	aTransform.m34 = 1.0 / (4.666667*controller.view.frame.size.width);
	//aTransform.m44 = 1.0;
	outTransform.toValue=[NSValue valueWithCATransform3D:aTransform];
	outTransform.removedOnCompletion = YES;
	topController.view.layer.anchorPoint = CGPointMake(-1*topController.view.frame.origin.x/topController.view.frame.size.width,0.5);
	topController.view.center=CGPointMake(0, self.view.frame.size.height/2);
    
	[topController.view.layer addAnimation:outTransform forKey:@"transform"];
    topController.view.layer.transform=aTransform;

    CABasicAnimation *slideAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
    //CGRect targetRect=CGRectMake(self.view.frame.size.width-controller.view.frame.size.width, (self.view.frame.size.height-controller.view.frame.size.height)/2, controller.view.frame.size.width, controller.view.frame.size.height);
    CATransform3D slideTransfrom=CATransform3DMakeTranslation(self.view.frame.size.width+NEW_CONTROLLER_SHADOW_WIDTH, 0, 0);
    slideAnimation.fromValue=[NSValue valueWithCATransform3D:slideTransfrom];
    slideAnimation.duration=5;
    slideAnimation.removedOnCompletion=YES;
    [self.view addSubview:controller.view];
    [controller.view.layer addAnimation:slideAnimation forKey:@"slidein"];
    controller.view.layer.shadowColor=[[UIColor blackColor] CGColor];
    controller.view.layer.shadowOpacity=1;
    controller.view.layer.shadowRadius=10;
    
    controller.view.frame=CGRectMake(self.view.frame.size.width-controller.view.frame.size.width, (self.view.frame.size.height-controller.view.frame.size.height)/2, controller.view.frame.size.width, controller.view.frame.size.height);
}

#pragma mark make animation



#pragma mark controllers

-(UIViewController*)topViewController{
    return [self.viewControllers lastObject];
}

-(UIViewController*)rootViewController{
    if(self.viewControllers.count)return [self.viewControllers objectAtIndex:0];
    return nil;
}

@end
