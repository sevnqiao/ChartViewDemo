//
//  LineChartView.h
//  BaseProject
//
//  Created by Xiong on 2017/8/25.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LineChartView;

#define LineValueEmpty @"LineValueEmpty"

@protocol LineChartViewDataSource <NSObject>

@required
// 底部标题
- (NSArray *)titlesArrayOfLineChartView:(LineChartView *)lineChartView;

@optional
// 折线图数据源
- (NSArray *)lineValuesArrayOfLineChartView:(LineChartView *)lineChartView;
- (NSArray *)barValuesArrayOfLineChartView:(LineChartView *)lineChartView;
- (NSArray *)colorsArrayOfLineChartView:(LineChartView *)lineChartView;

@end

@interface LineChartView : UIView

@property (assign, nonatomic) id <LineChartViewDataSource> dataSource;

@end
