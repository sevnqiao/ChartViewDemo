//
//  ChartView.h
//  BaseProject
//
//  Created by Xiong on 2017/8/22.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieChartView;

@protocol PieChartViewDataSource <NSObject>

@required
- (CGFloat)radiusOfPieChartView:(PieChartView *)pieChartView;
- (NSArray *)valuseArrayOfPieChartView:(PieChartView *)pieChartView;
- (NSArray *)colorsArrayOfPieChartView:(PieChartView *)pieChartView;


@end

@interface PieChartView : UIView

@property (assign, nonatomic) id <PieChartViewDataSource>dataSource;

@end
