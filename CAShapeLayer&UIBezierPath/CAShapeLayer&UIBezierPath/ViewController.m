//
//  ViewController.m
//  CAShapeLayer&UIBezierPath
//
//  Created by chairman on 16/5/23.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "ViewController.h"
#define kDefaultFrame CGRectMake(100, 100, 100, 100)
/** 9==100-82/2 */
#define kRoundFrame CGRectMake(100+9, 100+9, 82, 82)
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@interface ViewController ()
@property (nonatomic, strong) CAShapeLayer *layer;
@property (nonatomic, assign, getter=isCompleteAnimation) BOOL completeAnimation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self drawSolidRectangular];
//    [self drawHollowRectangular];
//    [self drawRoundedCornerRadiusShape];
//    [self drawFanshaped];
//    [self drawRound];
//    [self drawbyRoundingCornersWithTopRight];
//    [self drawOval];
//    [self drawCurve];
//    [self drawCurve2];
//    [self drawCurveWithAnimation];
//    [self drawCurveWithAnimation2];
//    [self drawCurveWithAnimation3];
//    [self drawRoundWithAnimation];
//    [self draw];
//    [self drawPie];
    [self darwPieWithAnimation];
}
/** 动画->饼图 点击屏幕 */
/**
 *  这种动画是利用一个layer覆盖在已经画好的饼图上面,然后对覆盖的layer'strokeEnd'做动画
 *  在自定义UIView里面使用self.bouns
 *  画图时候需要center这个center是这个UIView的中心点,而不是它在父容器的center
 */

- (void)darwPieWithAnimation {
    //* 最外层layer */
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kDefaultFrame cornerRadius:kDefaultFrame.size.height/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    NSArray *sections = @[@20,@10,@40,@60,@70];
    NSArray *sectionColors = @[[UIColor lightGrayColor],[UIColor yellowColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor purpleColor]];
    float total = 0.0,starAngle=M_PI/2,endAngle;
    for (NSInteger i=0; i<sections.count; i++) {
        total += [sections[i] floatValue];
    }
    CGPoint center = CGPointMake(kDefaultFrame.origin.x + kDefaultFrame.size.width/2,kDefaultFrame.origin.y + kDefaultFrame.size.height/2);
    for (NSInteger j=0; j<sections.count; j++) {
        /** 计算比例 */
        CGFloat scale = [sections[j] floatValue]/total;
        UIColor *color = sectionColors[j];
        endAngle = starAngle + scale * 2 * M_PI;
        //* 弧形layer */
        UIBezierPath *fanshapedPath = [UIBezierPath bezierPathWithArcCenter:center radius:(kDefaultFrame.size.height-10)/2 startAngle:starAngle endAngle:endAngle clockwise:YES];
        [fanshapedPath addLineToPoint:center];
        [fanshapedPath closePath];
        CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
        fanshapedLayer.path = fanshapedPath.CGPath;
        fanshapedLayer.fillColor = color.CGColor;
        /** 重新设置起始位置 */
        starAngle = endAngle;
        [layer addSublayer:fanshapedLayer];
    }
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.fromValue = @1.0;
    baseAnimation.toValue = @0.0;
    baseAnimation.duration = 2.0f;
    /** 逆时针的角度是负的*/
    UIBezierPath *coverPath = [UIBezierPath bezierPathWithArcCenter:center radius:kRoundFrame.size.height/2 startAngle:M_PI_2 endAngle: -2*M_PI+M_PI_2 clockwise:NO];
    CAShapeLayer *coverLayer = [CAShapeLayer layer];
    coverLayer.path = coverPath.CGPath;
    coverLayer.lineWidth = 10;
    coverLayer.fillColor = [UIColor whiteColor].CGColor;
    coverLayer.strokeColor = [UIColor whiteColor].CGColor;
    /** 保持动画执行的状态 */
    baseAnimation.removedOnCompletion = NO;//执行完成后动画对象不要移除
    baseAnimation.fillMode = kCAFillModeForwards;//保持当前状态
    [layer addSublayer:coverLayer];
    [coverLayer addAnimation:baseAnimation forKey:nil];
    self.layer = coverLayer;
}
//* 画饼图 */
- (void)drawPie {
    //* 最外层layer */
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kDefaultFrame cornerRadius:kDefaultFrame.size.height/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    NSArray *sections = @[@20,@10,@40,@60,@70];
    NSArray *sectionColors = @[[UIColor lightGrayColor],[UIColor yellowColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor purpleColor]];
    float total = 0.0,starAngle=0.0,endAngle;
    for (NSInteger i=0; i<sections.count; i++) {
        total += [sections[i] floatValue];
    }
    CGPoint center = CGPointMake(kDefaultFrame.origin.x + kDefaultFrame.size.width/2,kDefaultFrame.origin.y + kDefaultFrame.size.height/2);
    for (NSInteger j=0; j<sections.count; j++) {
        /** 计算比例 */
        CGFloat scale = [sections[j] floatValue]/total;
        UIColor *color = sectionColors[j];
        endAngle = starAngle + scale * 2 * M_PI;
        //* 弧形layer */
        UIBezierPath *fanshapedPath = [UIBezierPath bezierPathWithArcCenter:center radius:(kDefaultFrame.size.height-10)/2 startAngle:starAngle endAngle:endAngle clockwise:YES];
        [fanshapedPath addLineToPoint:center];
        [fanshapedPath closePath];
        CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
        fanshapedLayer.path = fanshapedPath.CGPath;
        fanshapedLayer.fillColor = color.CGColor;
        /** 重新设置起始位置 */
        starAngle = endAngle;
        [layer addSublayer:fanshapedLayer];
    }
    [self.view.layer addSublayer:layer];
}
/** 时光网APP 购票layer */
- (void)draw {
    CGSize finalSize = CGSizeMake(SCREEN_SIZE.width, 300);
    CGFloat layerHeight = finalSize.height/2;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    /** 左上点 */
    [path moveToPoint:CGPointMake(0, finalSize.height - layerHeight)];
    /** 左下点 */
    [path addLineToPoint:CGPointMake(0, finalSize.height - 1)];
    /** 右下点 */
    [path addLineToPoint:CGPointMake(finalSize.width, finalSize.height - 1)];
    /** 右上点 */
    [path addLineToPoint:CGPointMake(finalSize.width, layerHeight)];
    /** 圆弧 */
    [path addQuadCurveToPoint:CGPointMake(0, layerHeight) controlPoint:CGPointMake(SCREEN_SIZE.width/2, layerHeight - 40)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}
//* 动画画圆 */
- (void)drawRoundWithAnimation {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.fromValue = @0.0;
    baseAnimation.toValue = @1.0;
    baseAnimation.duration = 2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kDefaultFrame cornerRadius:kDefaultFrame.size.height/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 10;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [layer addAnimation:baseAnimation forKey:nil];
    [self.view.layer addSublayer:layer];
}

//* 动画绘制曲线 线边宽 */
- (void)drawCurveWithAnimation3 {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //* strokeEnd取值范围 0-1 */
    //* 初始状态 */
    baseAnimation.fromValue = @0.0;
    //* 最终 */
    baseAnimation.toValue = @1.0;
    baseAnimation.duration = 2.0f;
    
    CABasicAnimation *baseAnimation2 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    baseAnimation2.fromValue = @1.0;
    baseAnimation2.toValue = @10.0;
    baseAnimation2.duration = 2.0f;
    
    
    CGPoint starPoint = CGPointMake(50, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(170, 200);
    CGPoint controlPoint2 = CGPointMake(220, 400);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path moveToPoint:starPoint];
    //* 两个控制点 */
    [path addCurveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [layer addAnimation:baseAnimation forKey:nil];
    [layer addAnimation:baseAnimation2 forKey:nil];
    
    [self.view.layer addSublayer:layer];
}
//* 动画绘制曲线 中间向两边画*/
- (void)drawCurveWithAnimation2 {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    //* 初始状态 */
    baseAnimation.fromValue = @0.5;
    //* 最终 */
    baseAnimation.toValue = @0.0;
    baseAnimation.duration = 2.0f;
    
    CABasicAnimation *baseAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation2.fromValue = @0.5;
    baseAnimation2.toValue = @1.0;
    baseAnimation2.duration = 2.0f;
    
    CGPoint starPoint = CGPointMake(50, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(170, 200);
    CGPoint controlPoint2 = CGPointMake(220, 400);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path moveToPoint:starPoint];
    
    //* 两个控制点 */
    [path addCurveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [layer addAnimation:baseAnimation forKey:nil];
    [layer addAnimation:baseAnimation2 forKey:nil];
    [self.view.layer addSublayer:layer];
}
//* 动画绘制曲线 */
- (void)drawCurveWithAnimation {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //* strokeEnd取值范围 0-1 */
    //* 初始状态 */
    baseAnimation.fromValue = @0.0;
    //* 最终 */
    baseAnimation.toValue = @1.0;
    
    baseAnimation.duration = 2;
    
    CGPoint starPoint = CGPointMake(50, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(170, 200);
    CGPoint controlPoint2 = CGPointMake(220, 400);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path moveToPoint:starPoint];
    //* 两个控制点 */
    [path addCurveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [layer addAnimation:baseAnimation forKey:nil];
    [self.view.layer addSublayer:layer];
}
//* 画曲线2 */
- (void)drawCurve2 {
    //* 贝塞尔曲线的画法是由起点、终点、控制点三个参数来画的,控制点决定了它的曲率 */
    CGPoint starPoint = CGPointMake(50, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(170, 200);
    CGPoint controlPoint2 = CGPointMake(220, 400);
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(starPoint.x, starPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(controlPoint.x, controlPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [CALayer layer];
    layer3.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer4 = [CALayer layer];
    layer4.frame = CGRectMake(controlPoint2.x, controlPoint2.y, 5, 5);
    layer4.backgroundColor = [UIColor redColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path moveToPoint:starPoint];
    //* 两个控制点 */
    [path addCurveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:layer1];
    [self.view.layer addSublayer:layer2];
    [self.view.layer addSublayer:layer3];
    [self.view.layer addSublayer:layer4];
    [self.view.layer addSublayer:layer];
    
}

//* 画曲线 */
- (void)drawCurve {
    //* 贝塞尔曲线的画法是由起点、终点、控制点三个参数来画的,控制点决定了它的曲率 */
    CGPoint starPoint = CGPointMake(50, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(170, 200);
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(starPoint.x, starPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(controlPoint.x, controlPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [CALayer layer];
    layer3.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path moveToPoint:starPoint];
    //* 一个控制点 */
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:layer1];
    [self.view.layer addSublayer:layer2];
    [self.view.layer addSublayer:layer3];
    [self.view.layer addSublayer:layer];
    
}
//* 画椭圆 */
- (void)drawOval {
    //* 改变kDefaultFrame的Width或者Height不然就是一个圆 */
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:kDefaultFrame];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}
/** 画圆角(右上) */
- (void)drawbyRoundingCornersWithTopRight {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kDefaultFrame byRoundingCorners:UIRectCornerTopRight cornerRadii:kDefaultFrame.size];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer];
}
//* 画圆 */
- (void)drawRound {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kDefaultFrame cornerRadius:kDefaultFrame.size.height/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}
//* 画扇形形 */
- (void)drawFanshaped {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:50 startAngle:0 endAngle:M_PI/2 clockwise:YES];
    CGPoint centerPoint = self.view.center;
    [path addLineToPoint:centerPoint];
    //* 关闭路径 会形成一个扇形 */
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}
//* 画圆角图形 */
- (void)drawRoundedCornerRadiusShape {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kDefaultFrame cornerRadius:30];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}
//* 画空心矩形 */
- (void)drawHollowRectangular {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:kDefaultFrame];
    CAShapeLayer *layer = [CAShapeLayer layer];
    //* 设置路径 */
    layer.path = path.CGPath;
    //* 设置填充色 */
    layer.fillColor = [UIColor whiteColor].CGColor;
    //* 设置边框色 */
    layer.strokeColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}
//* 画实心矩形 */
- (void)drawSolidRectangular {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = kDefaultFrame;
    //* 设置layer背景颜色 */
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.duration = 1.0f;
    if (self.isCompleteAnimation) {
        self.completeAnimation = NO;
        baseAnimation.fromValue = @1.0;
        baseAnimation.toValue = @0.0;
    } else {
        self.completeAnimation = YES;
        baseAnimation.fromValue = @0.0;
        baseAnimation.toValue = @1.0;
    }
    /** 保持动画执行的状态 */
    baseAnimation.removedOnCompletion = NO;//执行完成后动画对象不要移除
    baseAnimation.fillMode = kCAFillModeForwards;//保持当前状态
    [self.layer addAnimation:baseAnimation forKey:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
