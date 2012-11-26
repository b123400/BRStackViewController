//
//  BRViewContainer.h
//  BRStackNavigationViewController
//
//  Created by b123400 on 18/11/12.
//  Copyright (c) 2012 b123400. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRViewContainer : UIView{
    UIView *view;
    UIView *coverView;
    BOOL isImage;
}
@property (strong,nonatomic) UIView *view;
@property (strong,nonatomic) UIView *coverView;
@property (assign,nonatomic) BOOL isImage;

-(id)initWithView:(UIView*)view;
-(void)setCoverViewOpacity:(float)opacity;

@end
