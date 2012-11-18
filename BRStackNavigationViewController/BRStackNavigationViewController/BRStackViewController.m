//
//  BRStackNavigationViewController.m
//  BRStackNavigationViewController
//
//  Created by b123400 on 11/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import "BRStackViewController.h"
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
    isPushing=isPopping=NO;
    panningView=nil;
    [self pushViewController:rootViewController];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *swipeRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark stack navigation

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
    
    frame=container.frame;
    frame.origin=CGPointMake(self.view.frame.size.width-container.frame.size.width, (self.view.frame.size.height-container.frame.size.height)/2);
    container.frame=frame;
    frame=container.frame;
    container.layer.transform=CATransform3DMakeTranslation(container.frame.size.width, 0, 0);
    
    [self.view addSubview:container];
    [self layoutWithPopProgress:0 completion:nil animated:YES];
}

-(void)panned:(UIPanGestureRecognizer*)recognizer{
    CGPoint locationInView=[recognizer locationInView:self.view];
    if(recognizer.state==UIGestureRecognizerStateBegan){
        for(int i=containers.count-1;i>=0;i--){
            BRViewContainer *thisContainer=[containers objectAtIndex:i];
            if(CGRectContainsPoint(thisContainer.frame, locationInView)){
                panningView=thisContainer;
                break;
            }
        }
    }else if(recognizer.state==UIGestureRecognizerStateChanged){
        [self layoutWithPopProgress:[recognizer translationInView:panningView].x/panningView.frame.size.width completion:nil animated:NO];
    }else if(recognizer.state==UIGestureRecognizerStateEnded){
        float velocity=[recognizer velocityInView:panningView].x;
        float pannedDistance=[recognizer translationInView:panningView].x;
        if(self.childViewControllers.count>1&&(velocity+pannedDistance>1000||self.view.frame.size.width-locationInView.x<30)){
            [self layoutWithPopProgress:1 completion:^(BOOL finished) {
                if(finished){
                    UIViewController *lastController=self.topViewController;
                    [lastController willMoveToParentViewController:nil];
                    [lastController removeFromParentViewController];
                    [lastController didMoveToParentViewController:nil];
                    [lastController.view removeFromSuperview];
                    [containers removeLastObject];
                }
            } animated:YES];
        }else{
            [self layoutWithPopProgress:0 completion:nil animated:YES];
        }
        panningView=nil;
    }else if(recognizer.state==UIGestureRecognizerStateCancelled){
        panningView=nil;
    }
}

#pragma mark make animation

-(void)layoutWithPopProgress:(float)popProgress completion:(void (^)(BOOL finished))completion animated:(BOOL)animated{
    float duration=0.5;
    
    for(int i=0;i<self.containers.count;i++){
        BRViewContainer *thisContainer=[self.containers objectAtIndex:i];
        if(thisContainer==[containers lastObject]){
            //if(thisContainer==[containers objectAtIndex:0])continue;
            //top view controller
            
            CATransform3D slideTransfrom=CATransform3DMakeTranslation(thisContainer.frame.size.width*popProgress, 0, 0);
            
            if(animated){
                CABasicAnimation *slideAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
                slideAnimation.fromValue=[NSValue valueWithCATransform3D:thisContainer.layer.transform];
                slideAnimation.toValue=[NSValue valueWithCATransform3D:slideTransfrom];
                slideAnimation.duration=duration;
                slideAnimation.removedOnCompletion=YES;
                slideAnimation.completion=completion;
                [thisContainer.layer addAnimation:slideAnimation forKey:@"slidein"];
            }
            
            thisContainer.layer.transform=slideTransfrom;
        }else{
            float prePoppedX=(self.view.frame.size.width-[containers.lastObject view].frame.size.width)/(containers.count-1)*i;
            float poppedX=0;
            if(containers.count>2){
                poppedX=(self.view.frame.size.width-[[containers objectAtIndex:containers.count-2] view].frame.size.width)/(containers.count-2)*i;
            }
            float currentX=prePoppedX+(poppedX-prePoppedX)*popProgress;
            
            CGRect frame=thisContainer.frame;
            frame.origin.x=currentX;
            float difference=frame.origin.x-thisContainer.frame.origin.x;
            thisContainer.layer.transform=CATransform3DTranslate(thisContainer.layer.transform, -1*difference, 0, 0);
            
            if(animated){
                CABasicAnimation *slideAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
                slideAnimation.fromValue=[NSValue valueWithCATransform3D:thisContainer.layer.transform];
                slideAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
                slideAnimation.duration=duration;
                slideAnimation.removedOnCompletion=YES;
                [thisContainer.layer addAnimation:slideAnimation forKey:@"slidein"];
            }
            thisContainer.layer.transform=CATransform3DMakeTranslation(0, 0, 0);
            thisContainer.frame=frame;
            
            if(i==containers.count-2){
                //this container will become top is popped
                float f = M_PI/4*(1-popProgress);
                CATransform3D aTransform = CATransform3DMakeRotation(f, 0, 1, 0);
                aTransform.m14 = (1.0 / (1500+self.view.frame.size.width*3))*(1-popProgress);//(4.666667*thisContainer.view.frame.size.width);
                //aTransform.m24 = 1.0/1100;
                aTransform.m34 = (1.0 / 1500)*(1-popProgress);//(4.666667*thisContainer.view.frame.size.width);
                //aTransform.m44 = 1.0;
                
                if(animated){
                    CABasicAnimation *outTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
                    //outTransform.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.97 :0.15 :1.00 :1.00];
                    outTransform.duration=duration;
                    outTransform.fromValue= [NSValue valueWithCATransform3D:thisContainer.view.layer.transform];
                    outTransform.toValue=[NSValue valueWithCATransform3D:aTransform];
                    outTransform.removedOnCompletion = YES;
                    
                    [thisContainer.view.layer addAnimation:outTransform forKey:@"transform"];
                }
                
                thisContainer.view.layer.anchorPoint = CGPointMake(0,0.5);
                thisContainer.view.center=CGPointMake(0, thisContainer.frame.size.height/2);
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
