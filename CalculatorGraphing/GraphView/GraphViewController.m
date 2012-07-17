//
//  GraphViewControllerViewController.m
//  Calculator
//
//  Created by Blazek Chris on 7/12/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrains.h"

@interface GraphViewController ()<GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *graphProgram;
@end

@implementation GraphViewController

	@synthesize graphProgram = _graphProgram;
	@synthesize graphView = _graphView;
	@synthesize programStack = _programStack;

	- (void) setProgramStack:(NSArray *)programStack
	{
		if( [programStack isKindOfClass:[NSArray class]]){
			_programStack = programStack;
			[self.graphView setNeedsDisplay];
		}
	}

	@synthesize axesPoint = _axesPoint;
	- (void) setAxesPoint:(CGPoint)axesPoint
	{
		_axesPoint = axesPoint;
		[self.graphView setNeedsDisplay];
	}

	- (void)viewDidLoad
	{
		[super viewDidLoad];
//		self.graphProgram.text = [CalculatorBrains descriptionOfProgram:self.programStack];
		self.graphProgram.text = [[[CalculatorBrains descriptionOfProgram:self.programStack] componentsSeparatedByString:@","] lastObject];
	}

	- (void)setGraphView:(GraphView *)graphView
	{
		_graphView = graphView;
		// enable pinch gestures in the FaceView using its pinch: handler
		[self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
		// recognize a pan gesture and modify our Model
		[self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleReScaleGesture:)]];
		self.graphView.dataSource = self;
	}

	- (void)handleReScaleGesture:(UIPanGestureRecognizer *)gesture
	{
		if ((gesture.state == UIGestureRecognizerStateChanged) ||
			(gesture.state == UIGestureRecognizerStateEnded)) {
			self.axesPoint = [gesture translationInView:self.graphView];
			[gesture setTranslation:CGPointZero inView:self.graphView];
		}
	}

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
		return YES;
//		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	- (NSArray *)drawFunctionGraphView:(GraphView *)sender
	{
		//return [CalculatorBrains descriptionOfProgram:self.programStack];
		return self.programStack;
	}

	- (CGPoint)setAxesCenterPoint:(GraphView *)sender
	{
		return self.axesPoint;
	}


@end
