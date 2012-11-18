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
#import "BRViewContainer.h"

#define NEW_CONTROLLER_SHADOW_WIDTH 20.0f
#define STACK_DISTANCE 20.0f

@interface BRStackViewController ()

@end

@implementation BRStackViewController
@synthesize containers;

-(id)initWithRootViewController:(UIViewController*)rootViewController{
    self=[super init];
    
    self.containers=[NSMutableArray array];
    isPushing=isPoping=NO;
    [self pushViewController:rootViewController];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark stack push

-(void)pushViewController:(UIViewController*)controller{
    isPushing=YES;
    
    CGRect frame=controller.view.frame;
    frame.size.width=MIN(frame.size.width, self.view.frame.size.width);
    frame.size.height=MIN(frame.size.height,self.view.frame.size.height);
    controller.view.frame=frame;
    
    BRViewContainer *container=[[BRViewContainer alloc]initWithView:controller.view];
    [containers addObject:container];
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    [self.view addSubview:container];
    [self layoutWithAnimationWithCompletion:^(BOOL finished) {
        isPushing=NO;
    }];
    
    controller.stackViewController=self;
}

#pragma mark make animation

-(void)layoutWithAnimationWithCompletion:(void (^)(BOOL))completion{
    float duration=5;
    if(isPushing){
        for(int i=0;i<self.containers.count;i++){
            BRViewContainer *thisContainer=[self.containers objectAtIndex:i];
            if(thisContainer==[containers lastObject]){
                if(thisContainer==[containers objectAtIndex:0])continue;
                //top view controller
                
                CGRect frame=thisContainer.frame;
                frame.origin=CGPointMake(self.view.frame.size.width-thisContainer.frame.size.width, (self.view.frame.size.height-thisContainer.frame.size.height)/2);
                thisContainer.frame=frame;
                
                CABasicAnimation *slideAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
                CATransform3D slideTransfrom=CATransform3DMakeTranslation(thisContainer.frame.size.width+NEW_CONTROLLER_SHADOW_WIDTH, 0, 0);
                slideAnimation.fromValue=[NSValue valueWithCATransform3D:slideTransfrom];
                slideAnimation.duration=duration;
                slideAnimation.removedOnCompletion=YES;
                [thisContainer.layer addAnimation:slideAnimation forKey:@"slidein"];
            }else{
                CGRect frame=thisContainer.frame;
                frame.origin.x=(self.view.frame.size.width-[self.containers.lastObject view].frame.size.width)/(containers.count-1)*i;
                float difference=frame.origin.x-thisContainer.frame.origin.x;
                thisContainer.frame=frame;

                CABasicAnimation *slideAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
                CATransform3D slideTransfrom=CATransform3DMakeTranslation(-1*difference, 0, 0);
                slideAnimation.fromValue=[NSValue valueWithCATransform3D:slideTransfrom];
                slideAnimation.duration=duration;
                slideAnimation.removedOnCompletion=YES;
                [thisContainer.layer addAnimation:slideAnimation forKey:@"slidein"];
                                
                CABasicAnimation *outTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
                //outTransform.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.97 :0.15 :1.00 :1.00];
                outTransform.duration=duration;
                outTransform.fromValue= [NSValue valueWithCATransform3D:thisContainer.view.layer.transform];
                float f = M_PI/6;
                CATransform3D aTransform = CATransform3DTranslate(CATransform3DMakeRotation(f, 0, 1, 0), 0, 0, 0);
                aTransform.m14 = 1.0 / 1100;//(4.666667*thisContainer.view.frame.size.width);
                aTransform.m34 = 1.0 / 1100;//(4.666667*thisContainer.view.frame.size.width);
                //aTransform.m44 = 1.0;
                outTransform.toValue=[NSValue valueWithCATransform3D:aTransform];
                outTransform.removedOnCompletion = YES;
                thisContainer.view.layer.anchorPoint = CGPointMake(0,0.5);
                thisContainer.view.center=CGPointMake(0, thisContainer.frame.size.height/2);
                
                [thisContainer.view.layer addAnimation:outTransform forKey:@"transform"];
                thisContainer.view.layer.transform=aTransform;
            }
        }
    }
}

#pragma mark controllers

-(UIViewController*)topViewController{
    return [self.childViewControllers lastObject];
}

-(UIViewController*)rootViewController{
    if(self.childViewControllers.count)return [self.childViewControllers objectAtIndex:0];
    return nil;
}

#pragma mark UINavigationViewController compatible

-(NSArray*)viewControllers{
    return self.childViewControllers;
}

@end
