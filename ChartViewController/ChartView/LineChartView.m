//
//  LineChartView.m
//  BaseProject
//
//  Created by Xiong on 2017/8/25.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import "LineChartView.h"

#define kAnimationTime 1.5

@interface LineChartView ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *lineValuesArray;
@property (strong, nonatomic) NSArray *barValuesArray;
@property (strong, nonatomic) NSArray *colorsArray;
@property (assign, nonatomic) CGFloat originWidth;
@property (assign, nonatomic) CGFloat lineMaxValue;
@property (assign, nonatomic) CGFloat lineMinValue;
@property (assign, nonatomic) CGFloat barMaxValue;
@property (assign, nonatomic) CGFloat barMinValue;

@end

@implementation LineChartView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.originWidth = 40;        
    }
    return self;
}

- (void)setDataSource:(id<LineChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    // 1.初始化数据源
    [self initArray];
    
    // 2.初始化 scrollView
    [self initScrollView];
    
    // 3.画横线和竖线
    [self drawHorizontalLine];
    [self drawVerticalLine];
    
    // 4.底部 title
    if (self.titleArray.count > 0)
    {
        [self drawBottomTitle];
    }
    
    // 5.折线图
    if (self.lineValuesArray.count > 0)
    {
        [self drawLineYTextLayer];
        [self drawValueLineLayer];
    }
    
    // 6.条形图
    if (self.barValuesArray.count > 0)
    {
        [self drawBarYTextLayer];
        [self drawValueBarLayer];
    }
}

- (void)initArray
{
    if ([self.dataSource respondsToSelector:@selector(lineValuesArrayOfLineChartView:)]) {
        self.lineValuesArray = [self.dataSource lineValuesArrayOfLineChartView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(titlesArrayOfLineChartView:)]) {
        self.titleArray = [self.dataSource titlesArrayOfLineChartView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(barValuesArrayOfLineChartView:)]) {
        self.barValuesArray = [self.dataSource barValuesArrayOfLineChartView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(colorsArrayOfLineChartView:)]) {
        self.colorsArray = [self.dataSource colorsArrayOfLineChartView:self];
    }
}

- (void)initScrollView
{
    CGFloat leftInsert = self.lineValuesArray.count > 0 ? self.originWidth : 0;
    CGFloat rightInsert = self.barValuesArray.count > 0 ? self.originWidth : 0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftInsert, 0, self.frame.size.width - leftInsert - rightInsert, self.frame.size.height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.contentSize = CGSizeMake((self.titleArray.count + 1) * self.originWidth, self.scrollView.frame.size.height);
    
    [UIView animateWithDuration:kAnimationTime
                     animations:^{
                         
                         self.scrollView.contentOffset = CGPointMake((self.titleArray.count + 1) * self.originWidth - self.scrollView.frame.size.width, 0);
                         
                     }];
}

#pragma mark - HorizontalLine, VerticalLine, BottomTitle
- (void)drawHorizontalLine
{
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    
    //画横线
    for (int i=0; i<5; i++)
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(self.originWidth * 0.5, i*originHeight + 0.5 * originHeight)];
        [path addLineToPoint:CGPointMake(self.originWidth * 0.5 + self.originWidth * self.titleArray.count, i*originHeight  + 0.5 * originHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5;
        [self.scrollView.layer addSublayer:shapeLayer];
    }
}

- (void)drawVerticalLine
{
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    
    //画竖线
    for (int i=0; i<self.titleArray.count; i++)
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(self.originWidth + self.originWidth * i, 0.5 * originHeight)];
        [path addLineToPoint:CGPointMake(self.originWidth + self.originWidth * i, 4*originHeight + 0.5 * originHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5;
        [self.scrollView.layer addSublayer:shapeLayer];
    }
}

- (void)drawBottomTitle
{
    for (int i = 0; i < self.titleArray.count; i++)
    {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(self.originWidth * 0.5 + self.originWidth * i, self.scrollView.frame.size.height - 14, self.originWidth, 14);
        textLayer.foregroundColor = [UIColor grayColor].CGColor;
        textLayer.alignmentMode = kCAGravityCenter;
        textLayer.fontSize = 12;
        textLayer.string = self.titleArray[i];
        [self.scrollView.layer addSublayer:textLayer];
    }
}

#pragma mark - LineView
- (void)drawLineYTextLayer
{
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSArray *array in self.lineValuesArray) {
        [yArray addObjectsFromArray:array];
    }
    
    CGFloat tempMax = 0;
    CGFloat tempMin = 0;
    for (int i = 0; i < yArray.count; i++)
    {
        CGFloat num = [yArray[i] floatValue];
        if (num > tempMax) {
            tempMax = num;
        }
        if (num < tempMin) {
            tempMin = num;
        }
    }
    
    CGFloat max = tempMax + (tempMax - tempMin) / 8;
    CGFloat min = tempMin - (tempMax - tempMin) / 8;
    CGFloat orginaNum = (max-min)/4;
    
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    for (int i = 0; i < 5; i ++)
    {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(0, 0.5 * originHeight + originHeight * i - 7, self.originWidth, 14);
        textLayer.foregroundColor = [UIColor grayColor].CGColor;
        textLayer.alignmentMode = kCAGravityCenter;
        textLayer.fontSize = 12;
        textLayer.string = [NSString stringWithFormat:@"%.1f", max - orginaNum * i];
        [self.layer addSublayer:textLayer];
    }
    
    _lineMaxValue = max;
    _lineMinValue = max - orginaNum * 4;
}

- (void)drawValueLineLayer
{
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    NSArray *colorArray = self.colorsArray.firstObject;
    for (int n = 0; n < self.lineValuesArray.count; n++)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        NSArray *valueArray = self.lineValuesArray[n];
        
        for (int i = 0; i < self.titleArray.count; i++)
        {
            CGFloat value = -CGFLOAT_MAX;
            if (valueArray.count > i) {
                value = [valueArray[i] floatValue];
            }else {
                continue;
            }
            if ([valueArray[i] isEqualToString:LineValueEmpty]) {
                continue;
            }
            
            CGFloat scale = (value - _lineMinValue) / (_lineMaxValue - _lineMinValue);
            CGFloat y = (1-scale) * originHeight * 4 + self.originWidth * 0.5;
            
            CGPoint point = CGPointMake(self.originWidth + self.originWidth * i, y);
            
            if (i == 0)
            {
                [bezierPath moveToPoint:point];
            }
            else
            {
                [bezierPath addLineToPoint:point];
            }
            [self drawPointWithPoint:point color:[colorArray objectAtIndex:n]];
        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.strokeColor = [[colorArray objectAtIndex:n] CGColor];
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.scrollView.layer addSublayer:shapeLayer];
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = kAnimationTime;
        animation.repeatCount = 1;
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [shapeLayer addAnimation:animation forKey:nil];
        
    }
}

- (void)drawPointWithPoint:(CGPoint)point color:(UIColor *)color
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:2 startAngle:-M_PI endAngle:3*M_PI clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.lineWidth = 1;
    [self.scrollView.layer addSublayer:shapeLayer];

}

#pragma mark - BarView
- (void)drawBarYTextLayer
{
    CGFloat tempMax = 0;
    CGFloat tempMin = 0;
    for (int i = 0; i < self.barValuesArray.count; i++)
    {
        CGFloat num = [self.barValuesArray[i] floatValue];
        if (num > tempMax) {
            tempMax = num;
        }
        if (num < tempMin) {
            tempMin = num;
        }
    }
    
    CGFloat max = tempMax + (tempMax - tempMin) / 8;
    CGFloat min = tempMin - (tempMax - tempMin) / 8;
    CGFloat orginaNum = (max-min)/4;
    
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    for (int i = 0; i < 5; i ++)
    {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(self.frame.size.width - self.originWidth, 0.5 * originHeight + originHeight * i - 7, self.originWidth, 14);
        textLayer.foregroundColor = [UIColor grayColor].CGColor;
        textLayer.alignmentMode = kCAGravityCenter;
        textLayer.fontSize = 12;
        textLayer.string = [NSString stringWithFormat:@"%.1f", max - orginaNum * i];
        [self.layer addSublayer:textLayer];
    }
    
    _barMaxValue = max;
    _barMinValue = max - orginaNum * 4;
}

- (void)drawValueBarLayer
{
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    
    for (int i = 0; i < self.titleArray.count; i++)
    {
        CGFloat value = -CGFLOAT_MAX;
        if (self.barValuesArray.count > i) {
            value = [self.barValuesArray[i] floatValue];
        }else {
            continue;
        }
        if ([self.barValuesArray[i] isEqualToString:LineValueEmpty]) {
            continue;
        }
        
        
        CGFloat scale = (value - _barMinValue) / (_barMaxValue - _barMinValue);
        
        CGFloat y = (1-scale) * originHeight * 4 + self.originWidth * 0.5;
        
        CGPoint point1 = CGPointMake(self.originWidth + self.originWidth * i, 0.5 * originHeight + originHeight * 4);
        CGPoint point2 = CGPointMake(self.originWidth + self.originWidth * i, y);
        
        [bezierPath moveToPoint:point1];
        [bezierPath addLineToPoint:point2];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [[self.colorsArray.lastObject colorWithAlphaComponent:0.5] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = self.originWidth/2;
    [self.scrollView.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = kAnimationTime;
    animation.repeatCount = 1;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:nil];
    
}
@end
