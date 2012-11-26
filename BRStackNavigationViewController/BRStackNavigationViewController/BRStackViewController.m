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
    
    swipeRecognizer.delegate=self;
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
    [self.view addSubview:container];
    if(self.containers.count==1){
        CATransform3D transform=CATransform3DIdentity;
        transform.m34=1/-900.f;
        transform=CATransform3DTranslate(transform, 0, 0, -400);
        transform=CATransform3DRotate(transform, M_PI*2/5, 0, 1, 0);
        container.layer.transform=transform;
    }else{
        container.layer.transform=CATransform3DMakeTranslation(container.frame.size.width, 0, 0);
    }
    
    [self layoutWithPopProgress:0 completion:nil animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //if([containers count]<=1)return NO;
    return YES;
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
        if(self.childViewControllers.count>1&&(velocity*1.5+pannedDistance>1000||self.view.frame.size.width-locationInView.x<30)){
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
    float duration=0.3;
    float shiftPerLayer=0.3;
    if(animated){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        if(completion){
            [CATransaction setCompletionBlock:^{
                completion(YES);
            }];
        }
    }
    for(int i=0;i<self.containers.count;i++){
        BRViewContainer *thisContainer=[self.containers objectAtIndex:i];
        if(thisContainer==[containers lastObject]){
            //if(thisContainer==[containers objectAtIndex:0])continue;
            //top view controller
            float xShift=thisContainer.frame.size.width*popProgress;
            if(animated&&popProgress==1){
                xShift+=NEW_CONTROLLER_SHADOW_WIDTH;
            }
            CATransform3D slideTransfrom=CATransform3DMakeTranslation(xShift, 0, 0);
            
            thisContainer.layer.transform=slideTransfrom;
        }else{
            float prePoppedX=(self.view.frame.size.width-[containers.lastObject view].frame.size.width)/(containers.count-1)*i;
            float poppedX=0;
            if(containers.count>2){
                poppedX=(self.view.frame.size.width-[[containers objectAtIndex:containers.count-2] view].bounds.size.width)/(containers.count-2)*i;
            }
            float currentX=prePoppedX+(poppedX-prePoppedX)*popProgress;
            
            CGRect frame=thisContainer.frame;
            frame.origin.x=currentX;

            thisContainer.frame=frame;
            
            if(i==containers.count-2){
                //this container will become top is popped
                CATransform3D aTransform =  CATransform3DIdentity;
                aTransform.m34 = (1.0 / -900.0f);//*(1-popProgress);//(4.666667*thisContainer.view.frame.size.width);
                aTransform=CATransform3DRotate(aTransform, M_PI_4*(1-popProgress), 0, 1, 0);

                thisContainer.view.layer.transform=aTransform;
            }
            if(i<=containers.count-2){
                float thisShift=(containers.count-1-i)*shiftPerLayer-shiftPerLayer*popProgress;
                thisShift=MIN(thisShift, 0.9);
                [thisContainer setCoverViewOpacity:thisShift];
            }
        }
    }
    if(animated){
        [CATransaction commit];
        [UIView commitAnimations];
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
