//
//  PDFView.m
//  TestA4Print
//
//  Created by Diogo Carneiro on 30/05/16.
//  Copyright © 2016 AppNinja. All rights reserved.
//

#import "PDFView.h"

@implementation PDFView

- (NSArray *)cardViews{
	
	return @[(CardView *)[self viewWithTag:1],
			 (CardView *)[self viewWithTag:2],
			 (CardView *)[self viewWithTag:3],
			 (CardView *)[self viewWithTag:4],
			 (CardView *)[self viewWithTag:5],
			 (CardView *)[self viewWithTag:6]];
	
}

@end
