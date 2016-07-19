//
//  MTKSleepView.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/17.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSleepView.h"
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/155.0 green:arc4random_uniform(255)/155.0 blue:arc4random_uniform(255)/155.0 alpha:0.7]

#define coorLineWidth 2
#define bottomLineMargin 20
#define coordinateOriginFrame CGRectMake(self.leftLineMargin, self.height - bottomLineMargin, coorLineWidth, coorLineWidth)  // 原点坐标
#define xCoordinateWidth (self.width - self.leftLineMargin - 25)
#define yCoordinateHeight (self.height - bottomLineMargin - 5)

@interface MTKSleepView ()
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@end

@implementation MTKSleepView

+(instancetype)charView
{
    MTKSleepView *chartView = [[self alloc] init];
    // 默认值
    chartView.frame = CGRectMake(10, 70, 300, 220);
    return chartView;
}

- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
    [self setUpCoordinateSystem];
    [self drawRectangular];

    // Drawing code
}

- (void)setYValues:(NSArray *)yValues{
    _yValues = yValues;
    CGFloat maxStrWidth = 0;
    for (NSString *yValue in yValues) {
        CGSize size = [yValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
        if (size.width > maxStrWidth) {
            maxStrWidth = size.width;
        }
    }
    self.leftLineMargin = maxStrWidth + 6;
}

- (NSDictionary *)textStyleDict{
    if (!_textStyleDict){
        UIFont *font = [UIFont systemFontOfSize:8];
        NSMutableParagraphStyle *sytle = [[NSMutableParagraphStyle alloc]init];
        sytle.alignment = NSTextAlignmentCenter;
        _textStyleDict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:sytle,NSStrokeWidthAttributeName:@3,NSStrokeColorAttributeName:[UIColor whiteColor]};
    }
    return _textStyleDict;
}

#pragma mark - 创建坐标系
-(void)setUpCoordinateSystem // 利用UIView作为坐标轴动态画出坐标系
{
    CGContextRef ctxy = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil,5, self.frame.size.height-20);
    CGPathAddLineToPoint(path, nil, self.frame.size.width-5, self.frame.size.height-20);
    CGContextSetLineWidth(ctxy, 2);
    CGContextSetLineCap(ctxy, kCGLineCapRound);
    CGContextAddPath(ctxy, path);
    CGContextDrawPath(ctxy, kCGPathStroke);
    CGPathRelease(path);
    CGFloat x = 0;
    NSMutableArray *xTextP = [NSMutableArray array];
    for (int i = 0; i < _xTexts.count; i++) {
        x = 5 + ((self.frame.size.width-10)/(_xTexts.count-1))*i;
        [xTextP addObject:[NSValue valueWithCGPoint:CGPointMake(x, self.frame.size.height-15)]];
        CGSize size = [_xTexts[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
         [_xTexts[i] drawAtPoint:CGPointMake(x - size.width * 0.5, self.frame.size.height-15) withAttributes:self.textStyleDict];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, x, self.frame.size.height-15);
        CGPathAddLineToPoint(path, nil,x,self.frame.size.height-15-3);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathEOFillStroke);
        CGPathRelease(path);

    }
    
}


#pragma mark - 画矩形
- (void)drawRectangular{
    for (int i = 0; i < _xValues.count; i++) {
//        if (i < _xValues.count - 1) {
            NSDictionary *dic1 = _xValues[i];
//            NSDictionary *dic2 = _xValues[i+1];
            //创建路径并获取句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //指定矩形 dic1[@"TIME"]
            CGRect rectangle = CGRectMake(([dic1[@"TIME"] floatValue])*((self.frame.size.width-10)/86400.0f)+5, 15.0f,[dic1[@"SLEEPTIME"] floatValue]*((self.frame.size.width-10)/86400.0f),self.frame.size.height-40);
            //将矩形添加到路径中
            CGPathAddRect(path,NULL,rectangle);
            //获取上下文
            CGContextRef currentContext =
            UIGraphicsGetCurrentContext();
            //将路径添加到上下文
            CGContextAddPath(currentContext, path);
            //设置矩形填充色
            UIColor *fillColor;
             UIColor *StrokeColor;
            if ([dic1[@"QUALITY"] intValue] == 0) {
               fillColor = [UIColor colorWithRed:238/255.0 green:190/255.0 blue:255/255.0 alpha:1.0f];
                StrokeColor = [UIColor colorWithRed:238/255.0 green:190/255.0 blue:255/255.0 alpha:0.8f];
            }
            else if([dic1[@"QUALITY"] intValue] == 1){
                fillColor = [UIColor colorWithRed:200/255.0 green:126/255.0 blue:238/255.0 alpha:1.0f];
                StrokeColor = [UIColor colorWithRed:200/255.0 green:126/255.0 blue:238/255.0 alpha:0.8f];
            }
            else{
                fillColor = [UIColor colorWithRed:133/255.0 green:90/255.0 blue:175/255.0 alpha:1.0f];
                StrokeColor = [UIColor colorWithRed:133/255.0 green:90/255.0 blue:175/255.0 alpha:0.8f];
            }
            [fillColor setFill];
            //矩形边框颜色
            [StrokeColor setStroke];
            //边框宽度
            CGContextSetLineWidth(currentContext,0.0f);
            
//            CGContextSetShadowWithColor(currentContext, CGSizeMake(5.0f, -8.0f), 5.0f, [UIColor colorWithRed:214/255.0 green:197/255.0 blue:117/255.0 alpha:1.0f].CGColor);
//            CGContextSetShadow(currentContext, CGSizeMake(5.0f, -5.0f), 5.0f);
            //绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);
//        }
    }
  }
@end
