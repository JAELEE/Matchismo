//
//  PlayingCard.h
//  Matchismo
//
//  Created by Kyle Adams on 6/12/13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;

@end
