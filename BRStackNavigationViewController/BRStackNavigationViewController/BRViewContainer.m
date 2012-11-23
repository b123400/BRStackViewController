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
@synthesize view,isImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
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
    [self addSubview:newView];
    
    self.view.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.view.layer.shadowOpacity=1;
    self.view.layer.shadowRadius=10;
    
    self.layer.shouldRasterize = YES;
    // Don't forget the rasterization scale
    // I spent days trying to figure out why retina display assets weren't working as expected
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    [self.view.layer setShadowPath:path];
    
    self.view.layer.anchorPoint = CGPointMake(0,0.5);
    self.view.center=CGPointMake(0, self.frame.size.height/2);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
