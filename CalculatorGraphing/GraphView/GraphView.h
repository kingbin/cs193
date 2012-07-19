//
//  GraphView.h
//  Calculator
//
//  Created by Blazek Chris on 7/12/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (NSArray *)drawFunctionGraphView:(GraphView *)sender;
- (NSDictionary *)useVariables:(GraphView *)sender;
- (CGPoint)drawAxes:(GraphView *)sender;
- (CGFloat)drawScale:(GraphView *)sender;
@end

@interface GraphView : UIView

//@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

@end
