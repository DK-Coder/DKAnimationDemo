//
//  SpreadAnimationButton.m
//  DKAnimationDemo
//
//  Created by xuli on 2016/12/19.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import "SpreadAnimationButton.h"

@interface SpreadAnimationButton()
{
    
}
@end

@implementation SpreadAnimationButton

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scalAnimation)];
    [self addGestureRecognizer:tapGesture];
}

- (void)scalAnimation
{
    if (!self.selected) {
        self.selected = YES;
        [UIView animateWithDuration:.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformScale(self.transform, 2.f, 2.f);
        } completion:^(BOOL finished) {
            if (finished) {
                self.transform = CGAffineTransformScale(self.transform, .5f, .5f);
            }
        }];
    } else {
        self.selected = NO;
    }
}
@end
