//
//  CardView.m
//  TestA4Print
//
//  Created by Diogo Carneiro on 30/05/16.
//  Copyright © 2016 AppNinja. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (UILabel *)cardTitleLabel{
	return [[self subviews] objectAtIndex:0];
}

- (UILabel *)cardIdLabel{
	return [[self subviews] objectAtIndex:1];
}

@end
