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
    _dk_arrayRandomColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor purpleColor],
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
    // 生成一个从0~数组count的随机数，随机数用于获取颜色数组中的相应颜色
    int index = arc4random_uniform((int)self.dk_arrayRandomColors.count);
    // 用户每按一下，就生成一个图片图层
    CALayer *moveLayer = [CALayer layer];
    // 图层图片的颜色设置
    moveLayer.contents = (id)[image changeColorTo:self.dk_arrayRandomColors[index]].CGImage;
    // 图层的起始位置与固定图层相同
    moveLayer.frame = imageLayer.frame;
    [self.layer addSublayer:moveLayer];
    
    // 为新生成的图片图层添加缩放弹簧动画
    CASpringAnimation *springForMoveLayer = [CASpringAnimation animationWithKeyPath:@"bounds"];
    // 缩放动画设置的大小是原大小的1.2倍
    springForMoveLayer.toValue = [NSValue valueWithCGRect:CGRectMake(0.f, 0.f, CGRectGetWidth(moveLayer.frame) * 1.2f, CGRectGetHeight(moveLayer.frame) * 1.2f)];
    // 动画持续时间
    springForMoveLayer.duration = .8f;
    // 设置模式，如果不设置默认会返回到原有状态。kCAFillModeForwards可以保持动画在最后状态不变
    springForMoveLayer.fillMode = kCAFillModeForwards;
    // 搭配fillMode使用，如果为kCAFillModeForwards那么就设置为NO
    springForMoveLayer.removedOnCompletion = NO;
    // 质量参数，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大。默认为1，且设置的时候必须大于0
    springForMoveLayer.mass = 1.f;
    // 刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快。默认为100，且设置的时候必须大于0
    springForMoveLayer.stiffness = 50.f;
    // 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快，默认为10，且设置的时候必须大于0
    springForMoveLayer.damping = 5.f;
    // 初始速率，动画视图的初始速度大小速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反。默认为0
    springForMoveLayer.initialVelocity = 20.f;
    
    // X方向上的位移
    CGFloat offsetX = arc4random_uniform(101) % 2 == 0 ? index * index : -(index * index);
    // 路径的终点，这里的终点可以是具体的某一点，也可以设置为偏移量。该偏移量相对于起始点来算。X轴正值表示向右偏移，负值表示向左偏移。Y轴正值表示向下偏移，负值表示向上偏移
    CGPoint endPoint = CGPointMake(offsetX, self.frame.size.height / 2.f - self.frame.origin.y);
    // 新建一个贝塞尔曲线的实例
    UIBezierPath *pathForMove = [UIBezierPath bezierPath];
    // 将曲线的起始点设置为新建图片图层的位置
    [pathForMove moveToPoint:moveLayer.position];
    // 这里创建一个二次贝塞尔曲线，大致的样式就是一个“S”曲线
    [pathForMove addCurveToPoint:endPoint controlPoint1:CGPointMake(120.f - index * index * index, endPoint.y / 3.f) controlPoint2:CGPointMake(-80.f + index * index * index, endPoint.y / 3.f * 2.f)];
    
    // 创建关键帧动画，keypath就是图层的属性，这里使用位置动画，所以keypath为position。其他keypath可以自行百度
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 关键帧动画的路径，这里设置为前面创建的曲线路径
    moveAnimation.path = pathForMove.CGPath;
    // 延迟时间。由于下面需要添加到动画组中。所以这里最后没有加CACurrentMediaTime()方法，如果单用需要加这个方法
//    moveAnimation.beginTime = springForMoveLayer.duration / 2.f;
    // 动画持续时间
    moveAnimation.duration = 2.f;
    // 同上
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;
    
    // 这里创建一个渐隐动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // 动画初始值
    opacityAnimation.fromValue = @(1.f);
    // 动画结束值。由于是渐隐动画，所以结束值设置为0
    opacityAnimation.toValue = @(0.f);
    // 动画持续时间
    opacityAnimation.duration = .5f;
    // 动画延迟的时间，同上
    opacityAnimation.beginTime = moveAnimation.duration - opacityAnimation.duration;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[springForMoveLayer, moveAnimation, opacityAnimation];
    animationGroup.duration = springForMoveLayer.duration + moveAnimation.duration;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [moveLayer addAnimation:animationGroup forKey:nil];
}
@end
