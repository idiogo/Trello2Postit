//
//  ViewController.h
//  TestA4Print
//
//  Created by Diogo Carneiro on 30/05/16.
//  Copyright © 2016 AppNinja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import <SVProgressHUD.h>
#import "CardView.h"

@interface ViewController : UIViewController{
	NSMutableArray *cards;
	NSArray *trelloLists;
}

@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;
@property (strong, nonatomic) IBOutlet UISegmentedControl *boardSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *illustrationView;
@property (strong, nonatomic) IBOutlet UISwitch *squarePostitSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *printBordersSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *illustrationViewArrow;
@property (strong, nonatomic) IBOutlet UIImageView *illustrationViewFail;

@end

