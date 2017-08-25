//
//  LineChartView.m
//  BaseProject
//
//  Created by Xiong on 2017/8/25.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import "LineChartView.h"

@interface LineChartView ()

@property (strong, nonatomic) UIScrollView *scrollView;


@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) CGFloat originWidth;

@property (assign, nonatomic) CGFloat maxValue;
@property (assign, nonatomic) CGFloat minValue;

@end

@implementation LineChartView


- (void)drawRect:(CGRect)rect {

    

}

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSourceArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.dataSourceArray = dataSourceArray;
        self.titleArray = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月"];
        self.originWidth = 40;
        
        // 初始化 scrollview
        [self initScrollView];
        // 画横线
        [self drawHorizontalLine];
        // 画竖线
        [self drawVerticalLine];
        // 画底部标签
        [self drawBottomTitle];
        // 画左侧刻度
        [self drawYTextLayer];
        // 画线
        [self drawValueLine];
        
        [UIView animateWithDuration:2
                         animations:^{
                            
                             self.scrollView.contentOffset = CGPointMake((self.titleArray.count + 1) * self.originWidth - self.scrollView.frame.size.width, 0);
                             
                         }];
    }
    return self;
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.originWidth, 0, self.frame.size.width - self.originWidth, self.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake((self.titleArray.count + 1) * self.originWidth, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
}

- (void)drawHorizontalLine
{
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    
    //画横线
    for (int i=0; i<5; i++)
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(self.originWidth * 0.5, i*originHeight + 0.5 * originHeight)];
        [path addLineToPoint:CGPointMake(self.originWidth * 0.5 + self.originWidth * self.dataSourceArray.count, i*originHeight  + 0.5 * originHeight)];
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

- (void)drawYTextLayer
{
    CGFloat tempMax = 0;
    CGFloat tempMin = 0;
    for (int i = 0; i < self.dataSourceArray.count; i++)
    {
        CGFloat num = [self.dataSourceArray[i] floatValue];
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
    
    _maxValue = max;
    _minValue = max - orginaNum * 4;
}

- (void)drawValueLine
{
    CGFloat originHeight = self.scrollView.frame.size.height / 5;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    
    for (int i = 0; i < self.titleArray.count; i++)
    {
        CGFloat value = [self.dataSourceArray[i] floatValue];
        CGFloat scale = (value - _minValue) / (_maxValue - _minValue);
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
        [self drawPointWithPoint:point];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [[[UIColor redColor] colorWithAlphaComponent:1] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 1;
    [self.scrollView.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2;
    animation.repeatCount = 1;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:nil];
}

- (void)drawPointWithPoint:(CGPoint)point
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:2 startAngle:-M_PI endAngle:3*M_PI clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.fillColor = [[UIColor redColor] CGColor];
    shapeLayer.lineWidth = 1;
    [self.scrollView.layer addSublayer:shapeLayer];

}


@end
