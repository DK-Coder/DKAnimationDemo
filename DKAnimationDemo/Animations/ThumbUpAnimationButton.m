//
//  ThumbUpAnimationButton.m
//  DKAnimationDemo
//
//  Created by xuli on 2016/12/19.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import "ThumbUpAnimationButton.h"
#import "UIImage+DKExtension.h"

@interface ThumbUpAnimationButton()
{
    CALayer *imageLayer;
}
@end

@implementation ThumbUpAnimationButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    
    return self;
}

- (void)sharedInit
{
    self.dk_arrayRandomColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor purpleColor],
                    [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbUpAnimation)];
    [self addGestureRecognizer:tapGesture];
    
    imageLayer = [CALayer layer];
    imageLayer.contents = (id)[UIImage imageNamed:@"Resources.bundle/Thumb.png"].CGImage;
    imageLayer.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:imageLayer];
}

- (void)thumbUpAnimation
{
    UIImage *image = [UIImage imageNamed:@"Resources.bundle/Thumb_Pressed.png"];
    if (_dk_ThumbUpPressedColor) {
        imageLayer.contents = (id)[image changeColorTo:_dk_ThumbUpPressedColor].CGImage;
    } else {
        imageLayer.contents = (id)image.CGImage;
    }
    
    int index = arc4random_uniform((int)self.dk_arrayRandomColors.count);
    CALayer *moveLayer = [CALayer layer];
    moveLayer.contents = (id)[image changeColorTo:self.dk_arrayRandomColors[index]].CGImage;
    moveLayer.frame = imageLayer.frame;
    [self.layer addSublayer:moveLayer];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.byValue = @(2.f);
    scaleAnimation.duration = .3f;
    
    CGPoint endPoint = CGPointMake(0.f, self.frame.size.height / 2.f - self.frame.origin.y);
    UIBezierPath *pathForMove = [UIBezierPath bezierPath];
    [pathForMove moveToPoint:moveLayer.position];
    [pathForMove addCurveToPoint:endPoint controlPoint1:CGPointMake(120.f - index * index * index, endPoint.y / 3.f) controlPoint2:CGPointMake(-80.f + index * index * index, endPoint.y / 3.f * 2.f)];
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = pathForMove.CGPath;
    moveAnimation.beginTime = scaleAnimation.duration;
    moveAnimation.duration = 2.f;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.f);
    opacityAnimation.toValue = @(0.f);
    opacityAnimation.duration = .5f;
    opacityAnimation.beginTime = scaleAnimation.duration + moveAnimation.duration - opacityAnimation.duration;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, moveAnimation, opacityAnimation];
    animationGroup.duration = scaleAnimation.duration + moveAnimation.duration;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [moveLayer addAnimation:animationGroup forKey:nil];
}
@end
