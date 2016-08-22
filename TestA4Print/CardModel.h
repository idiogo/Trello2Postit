//
//  CardModel.h
//  TestA4Print
//
//  Created by Diogo Carneiro on 30/05/16.
//  Copyright © 2016 AppNinja. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, CardType) {
	CardTypeNone,
	CardTypeIos,
	CardTypeAndroid
};

@interface CardModel : JSONModel

@property (assign, nonatomic) int idShort;
@property (strong, nonatomic) NSString *name;
@property BOOL detailingCard;
@property CardType cardType;

@end
