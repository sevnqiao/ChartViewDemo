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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2-64) dataSource:@[@"3",@"5",@"9",@"5",@"7",@"54",@"8",@"-3",@"1",@"-5"]];
    [self.view addSubview:lineChartView];
    
    
    
    
    
    PieChartView *chartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-64, self.view.frame.size.width, self.view.frame.size.height/2-64)];
    chartView.dataArray = @[@(0.1), @(0.25), @(0.2), @(0.1), @(0.15), @(0.2)];
    chartView.colorArray =@[HEX_COLOR(0xd32f35), HEX_COLOR(0xe653f1), HEX_COLOR(0xa46b3e), HEX_COLOR(0x2f4567), HEX_COLOR(0xaa4111), HEX_COLOR(0xd11111)];
    chartView.radiu = self.view.bounds.size.width/5;
    [self.view addSubview:chartView];
}


@end
