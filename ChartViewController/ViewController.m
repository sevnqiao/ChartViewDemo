//
//  ViewController.m
//  ChartViewController
//
//  Created by Xiong on 2017/8/25.
//  Copyright © 2017年 Xiong. All rights reserved.
//

#import "ViewController.h"
#import "LineChartView.h"
#import "PieChartView.h"

#define HEX_COLOR(hex)  [UIColor colorWithRed:((float)((hex &0xFF0000)>>16))/255.0 green:((float)((hex &0xFF00)>>8))/255.0 blue:((float)(hex &0xFF))/255.0 alpha:1] ///分类中已此宏


@interface ViewController ()<LineChartViewDataSource, PieChartViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2-64)];
    
    lineChartView.dataSource = self;
    
    [self.view addSubview:lineChartView];
    
    
    
    
    
    PieChartView *chartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-64, self.view.frame.size.width, self.view.frame.size.height/2-64)];
    
    chartView.dataSource = self;
    
    [self.view addSubview:chartView];
    
}


#pragma mark - LineChartViewDataSource
- (NSArray *)titlesArrayOfLineChartView:(LineChartView *)lineChartView
{
    return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月"];
}
- (NSArray *)lineValuesArrayOfLineChartView:(LineChartView *)lineChartView
{
    return @[@[@"3",LineValueEmpty,@"9",@"5",@"7",LineValueEmpty,@"8",@"-3",@"1",@"-5"],
             @[@"5",@"1",@"3",@"8",LineValueEmpty,LineValueEmpty,@"8",@"-6",@"6",@"-10"]
             ];
}
- (NSArray *)barValuesArrayOfLineChartView:(LineChartView *)lineChartView
{
    return @[@"3",LineValueEmpty,@"9",@"5",LineValueEmpty,@"54",@"8",@"-3",@"1",@"-5"];
}
- (NSArray *)colorsArrayOfLineChartView:(PieChartView *)pieChartView
{
    return @[@[[UIColor redColor], [UIColor greenColor]],
             [UIColor lightGrayColor]];
}


#pragma mark - PieChartViewDataSource
- (CGFloat)radiusOfPieChartView:(PieChartView *)pieChartView
{
    return self.view.bounds.size.width/5;
}
- (NSArray *)valuseArrayOfPieChartView:(PieChartView *)pieChartView
{
    return @[@(0.1), @(0.25), @(0.2), @(0.1), @(0.15), @(0.2)];
}
- (NSArray *)colorsArrayOfPieChartView:(PieChartView *)pieChartView
{
    return @[HEX_COLOR(0xd32f35), HEX_COLOR(0xe653f1), HEX_COLOR(0xa46b3e), HEX_COLOR(0x2f4567), HEX_COLOR(0xaa4111), HEX_COLOR(0xd11111)];
}



@end
