//
//  ViewController.m
//  DKAnimationDemo
//
//  Created by xuli on 2016/12/19.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import "ViewController.h"
#import "SpreadAnimationButton.h"
#import "ThumbUpAnimationButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIScrollView *rootScroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    rootScroll.contentSize = CGSizeMake(0.f, 1000.f);
    [self.view addSubview:rootScroll];
    
    SpreadAnimationButton *button = [[SpreadAnimationButton alloc] initWithFrame:CGRectMake(0.f, 100.f, 60.f, 60.f)];
    [button setImage:[UIImage imageNamed:@"Resources.bundle/Thumb.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Resources.bundle/Thumb_Pressed.png"] forState:UIControlStateSelected];
    [rootScroll addSubview:button];
    
    ThumbUpAnimationButton *button2 = [[ThumbUpAnimationButton alloc] initWithFrame:CGRectMake(100.f, 400.f, 60.f, 60.f)];
    [rootScroll addSubview:button2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
