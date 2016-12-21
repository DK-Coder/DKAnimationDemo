//
//  ThumbUpAnimationButton.h
//  DKAnimationDemo
//
//  Created by xuli on 2016/12/19.
//  Copyright © 2016年 dk-coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbUpAnimationButton : UIButton

@property (nonatomic, strong) UIColor *dk_ThumbUpPressedColor;  /**< 大拇指图片第一次被按下后的填充颜色*/

@property (nonatomic, strong) NSArray *dk_arrayRandomColors;  /**< 填充颜色数组，每次按下大拇指后随机生成的颜色从这个数组中抽取*/
@end
