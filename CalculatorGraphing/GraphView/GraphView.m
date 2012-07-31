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
//	@property (nonatomic) CGPoint axesPoint;
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


	- (CGPoint)convertToGraphCoordinateFromViewCoordinate:(CGPoint)coordinate withAxesPoint:(CGPoint)axesPoint {
		
		CGPoint graphCoordinate;
		
		graphCoordinate.x = (coordinate.x - axesPoint.x) / self.scale;
		graphCoordinate.y = (axesPoint.y - coordinate.y) / self.scale;
		
		return graphCoordinate;
	}

	- (CGPoint) convertToViewCoordinateFromGraphCoordinate:(CGPoint)coordinate withAxesPoint:(CGPoint)axesPoint{
		
		CGPoint viewCoordinate;
		
		viewCoordinate.x = (coordinate.x * self.scale) + axesPoint.x;
		viewCoordinate.y = axesPoint.y - (coordinate.y * self.scale);
		
		return viewCoordinate;
	}

	- (void)drawTrigFunction:(NSString *)program withAxesPoint:(CGPoint)axesPoint inContext:(CGContextRef)context
	{
		UIGraphicsPushContext(context);
		
		CGFloat startingX = self.bounds.origin.x;
		CGFloat endingX = self.bounds.origin.x + self.bounds.size.width;
		CGFloat increment = 1/(self.contentScaleFactor * self.scale); // To enable iteration over pixels
		
		BOOL firstPoint = YES;
		
		// Iterate over the horizontal pixels, plotting the corresponding y values
		for (CGFloat x = startingX; x<= endingX; x+=increment) {
			// Identify the starting X point for the curve and convert to graph coordinates.
			// Then retrieve the corresponding Y value and convert it back to view coordindates
			CGPoint coordinate;
			coordinate.x = x;
			coordinate = [self convertToGraphCoordinateFromViewCoordinate:coordinate withAxesPoint:axesPoint];
			
//			double yValue = [CalculatorBrains runProgram:program usingVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:coordinate.x] forKey:@"x"]];
//			coordinate.y = yValue;
//			coordinate.y = [self.dataSource YValueForXValue:coordinate.x inGraphView:self];
			
			double d = [[[DDMathEvaluator sharedMathEvaluator] evaluateString:program withSubstitutions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:coordinate.x],@"x",nil]] doubleValue];
			coordinate.y = d;
			coordinate = [self convertToViewCoordinateFromGraphCoordinate:coordinate withAxesPoint:axesPoint];
			coordinate.x = x;
			
			// Handle the edge cases
			if (coordinate.y == NAN || coordinate.y == INFINITY || coordinate.y == -INFINITY)
				continue;
			
			if (firstPoint) {
				CGContextMoveToPoint(context, coordinate.x, coordinate.y);
				firstPoint = NO;
			}
			
			CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
			
		}
		CGContextStrokePath(context);
		
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

	- (void)drawAxes:(CGPoint)axesPoint inContext:(CGContextRef)context
	{
		UIGraphicsPushContext(context);
		[AxesDrawer drawAxesInRect:self.bounds originAtPoint:axesPoint scale:self.scale];
		UIGraphicsPopContext();
	}

	- (void)drawProgram:(NSArray *) function atAxesPoint:(CGPoint)axesPoint inContext:(CGContextRef)context
	{
		NSArray *functionArray = [[CalculatorBrains descriptionOfProgram:function] componentsSeparatedByString:@","];
		
		for(NSString *s in functionArray){
			NSMutableString	 *f = [NSMutableString stringWithFormat:@"%@", s];
			[f replaceOccurrencesOfString:@"x" withString:@"$x" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
			[f replaceOccurrencesOfString:@"y" withString:@"$y" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
			[f replaceOccurrencesOfString:@"z" withString:@"$z" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
			if ([f rangeOfString:@"Tan"].location != NSNotFound
				|| [f rangeOfString:@"Sin"].location != NSNotFound
				|| [f rangeOfString:@"Cos"].location != NSNotFound
				|| [f rangeOfString:@"SQRT"].location != NSNotFound) {
				[self drawTrigFunction:f withAxesPoint:axesPoint inContext:context];
			}
			else {
				//double d = topPoint.y - ( [[f numberByEvaluatingString] doubleValue] * self.scale );
				//[[DDMathEvaluator sharedMathEvaluator] evaluateString:f withSubstitutions:[self.dataSource useVariables:self]];
				double d = axesPoint.y - ( [[[DDMathEvaluator sharedMathEvaluator] evaluateString:f withSubstitutions:[self.dataSource useVariables:self]] doubleValue] * self.scale );

				[self drawLineFunction:d inContext:context];
			}
		}
	}

	- (void)drawRect:(CGRect)rect
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGPoint axesPoint = [self.dataSource drawAxes:self];
		self.scale = [self.dataSource drawScale:self];
		
		[self drawAxes:axesPoint inContext:context];
		
		// Draw Function
		NSArray *function = [self.dataSource drawFunctionGraphView:self];
		[self drawProgram:function atAxesPoint:axesPoint inContext:context];
	}

@end
