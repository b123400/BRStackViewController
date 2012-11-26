//
//  BRViewContainer.m
//  BRStackNavigationViewController
//
//  Created by b123400 on 18/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BRViewContainer.h"

@implementation BRViewContainer
@synthesize view,isImage,coverView;

-(id)init{
    self=[super init];
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.coverView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self setCoverViewOpacity:0];
    self.coverView.backgroundColor=[UIColor blackColor];
    [self addSubview:coverView];
    return self;
}
-(id)initWithView:(UIView*)_view{
    self=[self init];
    self.view=_view;
    return self;
}

-(void)setView:(UIView *)newView{
    if(self.view){
        [self.view removeFromSuperview];
    }
    view=newView;
    CGRect frame=newView.frame;
    frame.origin.x=frame.origin.y=0;
    newView.frame=frame;
    
    frame=self.frame;
    frame.size=newView.frame.size;
    self.frame=frame;
    [self insertSubview:newView belowSubview:coverView];
    
    self.view.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.view.layer.shadowOpacity=0.5;
    self.view.layer.shadowRadius=5;
    
    self.layer.shouldRasterize = YES;
    // Don't forget the rasterization scale
    // I spent days trying to figure out why retina display assets weren't working as expected
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    [self.view.layer setShadowPath:path];
    
    self.view.layer.anchorPoint = CGPointMake(0,0.5);
    self.view.center=CGPointMake(0, self.frame.size.height/2);
    
    coverView.layer.anchorPoint=self.view.layer.anchorPoint;
    coverView.center=self.view.center;
}
-(void)setCoverViewOpacity:(float)opacity{
    if(opacity==0){
        coverView.hidden=YES;
    }else{
        coverView.hidden=NO;
    }
    coverView.layer.opacity=opacity;
    if(self.view){
        coverView.layer.transform=self.view.layer.transform;
    }
}



@end
