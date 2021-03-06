
//
//  PieChartView.m
//  BaseProject
//
//  Created by Xiong on 2017/8/22.
//  Copyright © 2017年 sujp. All rights reserved.
//

#import "PieChartView.h"

#define kAnimationTime 1.5
#define kHeight self.frame.size.height
#define kWidth self.frame.size.width

@interface PieChartView ()

@property (strong, nonatomic) NSMutableArray *pathArray;
@property (strong, nonatomic) NSMutableArray *layerArray;
@property (assign, nonatomic) NSInteger selectIndex;
@property (assign, nonatomic) CGPoint defaultArcPoint;

@property (assign, nonatomic) CGFloat radiu;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *colorArray;

@end

@implementation PieChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layerArray = [NSMutableArray array];
        self.pathArray = [NSMutableArray array];
        self.defaultArcPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.radiu = MIN(self.frame.size.width/2, self.frame.size.height/2);
        self.selectIndex = 0;
    }
    return self;
}

- (void)setDataSource:(id<PieChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if ([dataSource respondsToSelector:@selector(valuseArrayOfPieChartView:)]) {
        self.dataArray =  [dataSource valuseArrayOfPieChartView:self];
    }
    if ([dataSource respondsToSelector:@selector(colorsArrayOfPieChartView:)]) {
        self.colorArray =  [dataSource colorsArrayOfPieChartView:self];
    }
    if ([dataSource respondsToSelector:@selector(radiusOfPieChartView:)]) {
        self.radiu = [dataSource radiusOfPieChartView:self];
        if (self.radiu > MIN(self.frame.size.width/2, self.frame.size.height/2)) {
            self.radiu = MIN(self.frame.size.width/2, self.frame.size.height/2);
        }
    }
    
    // 画各部分的扇形
    [self drawPieViewWithDataArray:self.dataArray];
    
    // 画一个遮盖的 layer 以形成展示的动画效果
    [self coverLayer];
}

- (void)drawPieViewWithDataArray:(NSArray *)dataArray
{
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 0;
    for (int i = 0; i < dataArray.count; i++)
    {
        CGFloat percent = [[dataArray objectAtIndex:i] floatValue];
        
        endAngle = startAngle + percent * M_PI * 2;
        
        CGPoint arcPoint = CGPointMake(self.defaultArcPoint.x, self.defaultArcPoint.y);
        
        // 1.画扇形
        [self drawChildPieWithPercent:percent
                             arcPoint:arcPoint
                                radiu:self.radiu
                           startAngle:startAngle
                             endAngle:endAngle
                                color:self.colorArray[i]
                             isSelect:i == self.selectIndex];
        
        // 2.画标注文字
        [self drawTextWithContent:[NSString stringWithFormat:@"占比%.2f", percent]
                          percent:percent
                         arcPoint:arcPoint
                            radiu:self.radiu
                       startAngle:startAngle
                         endAngle:endAngle
                            color:self.colorArray[i]
                      nextPercent:i+1 < dataArray.count ? [[dataArray objectAtIndex:i+1] floatValue] : 0];
        
        startAngle = endAngle;
    }
}

- (void)coverLayer
{
    // 遮盖的圆
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.strokeColor = self.backgroundColor.CGColor;
    backLayer.lineWidth = self.radiu + 10;
    
    UIBezierPath *backLayerPath = [UIBezierPath bezierPathWithArcCenter:self.defaultArcPoint
                                                                 radius:backLayer.lineWidth/2
                                                             startAngle:-M_PI_2
                                                               endAngle:3 * M_PI_2
                                                              clockwise:YES];
    backLayer.path = backLayerPath.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = kAnimationTime;
    animation.repeatCount = 1;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [backLayer addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:backLayer];
}

- (void)drawChildPieWithPercent:(CGFloat)percent arcPoint:(CGPoint)arcPoint radiu:(CGFloat)radiu startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color isSelect:(BOOL)isSelect
{
    CGPoint startPoint = CGPointMake(arcPoint.x + radiu * cos(startAngle), arcPoint.y + radiu * sin(startAngle));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:arcPoint];
    [bezierPath addLineToPoint:startPoint];
    [bezierPath addArcWithCenter:arcPoint radius:radiu startAngle:startAngle endAngle:endAngle clockwise:YES];
    [bezierPath addLineToPoint:arcPoint];
    
    CGFloat padding = isSelect ? 10 : 0;
    CGPoint point = CGPointMake(padding * cos(startAngle + (endAngle-startAngle)/2) ,
                                   padding * sin(startAngle + (endAngle-startAngle)/2));
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;

    layer.frame = CGRectMake(point.x, point.y, kWidth, kHeight);
    layer.path = bezierPath.CGPath;
    layer.fillColor = color.CGColor;
    layer.strokeColor = color.CGColor;
    
    [self.layer addSublayer:layer];

    [_pathArray addObject:bezierPath];
    [_layerArray addObject:layer];
    
    
}

- (void)drawTextWithContent:(NSString *)content percent:(CGFloat)percent arcPoint:(CGPoint)arcPoint radiu:(CGFloat)radiu startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color nextPercent:(CGFloat)nextPercent
{
    CGPoint point1 = CGPointMake(arcPoint.x + radiu * cos(startAngle + percent * M_PI), arcPoint.y + radiu * sin(startAngle + percent * M_PI));
    
    if ( nextPercent < 0.1 && nextPercent != 0) {
        radiu += 0.5*radiu;
    }
    
    
    CGPoint point2 = CGPointMake(arcPoint.x + (radiu + 20) * cos(startAngle + percent  * M_PI), arcPoint.y + (radiu + 20) * sin(startAngle + percent * M_PI));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point1];
    [bezierPath addLineToPoint:point2];
    
    CGPoint point3 = CGPointZero;
    point3.y = point2.y;
    if (point2.x > arcPoint.x)
    {
        point3.x = point2.x + 60;
    }else
    {
        point3.x = point2.x - 60;
    }
    [bezierPath addLineToPoint:point3];

    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.path = bezierPath.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = color.CGColor;
    [self.layer addSublayer:lineLayer];
    
    
    CATextLayer *textLayer = [CATextLayer layer];
    if (point2.x > arcPoint.x)
    {
        textLayer.frame = CGRectMake(point2.x, point3.y-15, fabs(point3.x-point2.x), 15);
    }else
    {
        textLayer.frame = CGRectMake(point3.x, point3.y-15, fabs(point3.x-point2.x), 15);
    }
    
    textLayer.foregroundColor = color.CGColor;
    textLayer.fontSize = 12;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.string = content;
    [self.layer addSublayer:textLayer];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat totalPercent = 0;
    
    for (int i = 0; i<_pathArray.count; i++)
    {
        UIBezierPath *path = _pathArray[i];
        CAShapeLayer *layer = self.layerArray[i];
        
        CGFloat percent = [self.dataArray[i] floatValue];
        
        if ([path containsPoint:touchPoint])
        {
            self.selectIndex = i;
            
            CGFloat padding = 10;
            
            CGFloat startAngle = totalPercent * M_PI * 2 - M_PI_2;
            CGFloat endAngle = startAngle + M_PI * 2 * percent;
            
            layer.frame = CGRectMake(padding * cos(startAngle + (endAngle-startAngle)/2),
                                     padding * sin(startAngle + (endAngle-startAngle)/2),
                                     kWidth,
                                     kHeight);
        }
        else
        {
            layer.frame = self.bounds;
        }
        totalPercent += percent;
    }
}

@end
