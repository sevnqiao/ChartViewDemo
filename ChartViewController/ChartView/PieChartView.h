//
//  ChartView.h
//  BaseProject
//
//  Created by Xiong on 2017/8/22.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PieChartView : UIView

@property (assign, nonatomic) CGFloat radiu;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *colorArray;

@end
