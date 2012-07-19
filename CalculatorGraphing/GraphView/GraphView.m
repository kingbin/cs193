//
//  GraphView.m
//  Calculator
//
//  Created by Blazek Chris on 7/12/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "GraphView.h"
#import "CalculatorBrains.h"
#import "AxesDrawer.h"

#import "DDMathParser.h" // Using this to evaluate the NSString in my description seperated by ',' to a NSNumber

@interface GraphView()
	@property (nonatomic) CGFloat scale;
@end


@implementation GraphView

@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 10
@synthesize scale = _scale;
- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}

- (void)drawTrigFunction:(CGPoint)p /*withRadius:(CGFloat)radius*/ inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
//    CGContextBeginPath(context);
//    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
//    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawLineFunction:(CGFloat)y inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, y );
	CGContextAddLineToPoint(context, self.bounds.size.width, y );
	[[UIColor redColor] setStroke];
	CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawAxes:(CGPoint)topPoint inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:topPoint scale:self.scale];
    UIGraphicsPopContext();
}

- (void)drawProgram:(NSArray *) function withAxisPoint:(CGPoint)topPoint inContext:(CGContextRef)context
{
	NSArray *functionArray = [[CalculatorBrains descriptionOfProgram:function] componentsSeparatedByString:@","];
	
	for(NSString *s in functionArray){
		NSMutableString	 *f = [NSMutableString stringWithFormat:@"%@", s];
		[f replaceOccurrencesOfString:@"x" withString:@"$x" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
		[f replaceOccurrencesOfString:@"y" withString:@"$y" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
		[f replaceOccurrencesOfString:@"z" withString:@"$z" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
		
		if ([f isEqualToString:@"Tan"] || [f isEqualToString:@"Sin"]  || [f isEqualToString:@"Cos"] ) {
			[self drawTrigFunction:topPoint inContext:context];
		}
		else {
			//double d = topPoint.y - ( [[f numberByEvaluatingString] doubleValue] * self.scale );
			//[[DDMathEvaluator sharedMathEvaluator] evaluateString:f withSubstitutions:[self.dataSource useVariables:self]];
			double d = topPoint.y - ( [[[DDMathEvaluator sharedMathEvaluator] evaluateString:f withSubstitutions:[self.dataSource useVariables:self]] doubleValue] * self.scale );

			[self drawLineFunction:d inContext:context];
		}
	}
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint p = [self.dataSource drawAxes:self];
	self.scale = [self.dataSource drawScale:self];
	
	[self drawAxes:p inContext:context];
	
	// Draw Function
	NSArray *function = [self.dataSource drawFunctionGraphView:self];
	[self drawProgram:function withAxisPoint:p inContext:context];
}


@end
