//
//  LineChartView.h
//  BaseProject
//
//  Created by Xiong on 2017/8/25.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartView : UIView

@property (strong, nonatomic) NSArray *dataSourceArray;
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSourceArray;
@end
