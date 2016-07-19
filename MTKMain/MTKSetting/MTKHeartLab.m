//
//  MTKHeartLab.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/6/15.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKHeartLab.h"

@implementation MTKHeartLab


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawHRView:self.hrStr];
}

- (void)drawHRView:(NSString *)hr{
    NSArray *xPoin = @[@"0",@"60",@"100",@"140",@"140"];
    NSArray *hrStype = @[MtkLocalizedString(@"hearRate_type2"),MtkLocalizedString(@"hearRate_type1"),MtkLocalizedString(@"hearRate_type3")];
    NSArray *xColor = @[[UIColor colorWithRed:47/255.0 green:145/255.0 blue:206/255.0 alpha:1],[UIColor colorWithRed:47/255.0 green:145/255.0 blue:206/255.0 alpha:1],[UIColor colorWithRed:86/255.0 green:170/255.0 blue:48/255.0 alpha:1],[UIColor colorWithRed:241/255.0 green:20/255.0 blue:73/255.0 alpha:1],[UIColor colorWithRed:241/255.0 green:20/255.0 blue:73/255.0 alpha:1]];
    CGFloat x = 0.0;
    float with = _lineWith?_lineWith:6;
     UIColor *fillColor;
    UIFont *font = [UIFont systemFontOfSize:10];
    NSMutableParagraphStyle *sytle = [[NSMutableParagraphStyle alloc]init];
    sytle.alignment = NSTextAlignmentCenter;
    NSDictionary *_textStyleDict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:sytle,NSForegroundColorAttributeName:[UIColor grayColor]};
    for (int i = 0; i < xPoin.count; i ++) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetLineWidth(ctx, with);
        x = 20 + ([xPoin[i] floatValue]>140?hr.intValue:[xPoin[i] floatValue])/140.0 * (self.frame.size.width-40);
        CGPathMoveToPoint(path, nil, x, self.frame.size.height - 16);
        CGPathAddLineToPoint(path, nil,20 + [xPoin[(i>0 && i < xPoin.count)?i-1:i] floatValue]/140.0 * (self.frame.size.width-40),self.frame.size.height - 16);
        if (i >= 0 && i< xPoin.count) {
            fillColor = (UIColor *)xColor[i];
            CGContextSetStrokeColorWithColor(ctx,fillColor.CGColor);
        }
        if (i == 0 || i == xPoin.count - 1) {
            CGContextSetLineCap(ctx, kCGLineCapRound);
        }
        else{
            CGContextSetLineCap(ctx, kCGLineCapButt);
        }
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        CGPathRelease(path);
        
        //坐标文字
        if (i < xPoin.count - 1) {
            CGSize size = [xPoin[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:_textStyleDict context:nil].size;
            if (i == xPoin.count - 2) {
                [([hr intValue]>140?hr:xPoin[i]) drawAtPoint:CGPointMake(x - size.width * 0.5, self.frame.size.height-13) withAttributes:_textStyleDict];
            }
            else{
                [xPoin[i] drawAtPoint:CGPointMake(x - size.width * 0.5, self.frame.size.height-12) withAttributes:_textStyleDict];
            }
        }
        
        //绘制心率状态
        if (i > 0 && i < xPoin.count - 1) {
            NSDictionary *textStyleDict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:sytle,NSForegroundColorAttributeName:fillColor};
            CGSize size = [hrStype[i-1] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textStyleDict context:nil].size;
            float lasx = 20 + ([xPoin[i-1] floatValue]>140?140:[xPoin[i-1] floatValue])/140.0 * (self.frame.size.width-40);;
            [hrStype[i-1] drawAtPoint:CGPointMake((x+lasx)/2 - size.width * 0.5, self.frame.size.height-12) withAttributes:textStyleDict];
        }
    }
 
    //绘制心率图标
    UIColor *hrFillColor;
     UIFont *font1 = [UIFont systemFontOfSize:12];
    _textStyleDict = @{NSFontAttributeName:font1,NSParagraphStyleAttributeName:sytle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    if (hr.intValue < 60) {
        hrFillColor = [UIColor colorWithRed:47/255.0 green:145/255.0 blue:206/255.0 alpha:1];
    }
    else if (hr.intValue >= 60 && hr.intValue < 100){
        hrFillColor = [UIColor colorWithRed:86/255.0 green:170/255.0 blue:48/255.0 alpha:1];
    }
    else{
        hrFillColor = [UIColor colorWithRed:241/255.0 green:20/255.0 blue:73/255.0 alpha:1];
    }
    
    //心率所在位置
    CGFloat hrOrigin = 20 + ([hr floatValue]>140?140:[hr floatValue])/140.0 * (self.frame.size.width-40);
    CGSize size = [hr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:_textStyleDict context:nil].size;
    
    
    //指定矩形
    
     CGContextRef context = UIGraphicsGetCurrentContext();
    /*画圆角矩形*/
    CGContextMoveToPoint(context, hrOrigin - (size.width+4)/2+2, self.frame.size.height - 16 - with/2 - size.height );  // 开始坐标左边开始(视图高度-线离底部高度-线宽度一半-字体高度)
    CGContextAddArcToPoint(context, hrOrigin - (size.width+4)/2, self.frame.size.height - 16 - with/2 - size.height, hrOrigin - (size.width+4)/2, 10, 0.5);  // 左上角角度
    CGContextAddArcToPoint(context, hrOrigin - (size.width+4)/2, 14, hrOrigin - 2, 13, 0.5); // 左下角角度
    CGContextAddLineToPoint(context, hrOrigin-2, 14);
    CGContextAddLineToPoint(context, hrOrigin, 16);
    CGContextAddLineToPoint(context, hrOrigin+2, 14);
    CGContextAddArcToPoint(context, hrOrigin + (size.width+4)/2, 14, hrOrigin + (size.width+4)/2, 10, 0.5); // 右下角
    CGContextAddArcToPoint(context, hrOrigin + (size.width+4)/2, self.frame.size.height - 16 - with/2 - size.height, hrOrigin - (size.width+4)/2+2, self.frame.size.height - 16 - with/2 - size.height, 0.5); // 右上角
    [hrFillColor setFill];
    CGContextSetStrokeColorWithColor(context,hrFillColor.CGColor);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径

   [hr drawAtPoint:CGPointMake(hrOrigin - size.width * 0.5,self.frame.size.height - 16 - with/2 - size.height - 4) withAttributes:_textStyleDict];//开始(视图高度-线离底部高度-线宽度一半-字体高度 - 偏移高度)
    
    
}
@end
