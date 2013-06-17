//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kyle Adams on 6/14/13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *facedUpCards;
@property (nonatomic) int score;
@property (nonatomic) NSString *flipDescription;
@end

@implementation CardMatchingGame


//Lazy instantiation
-(NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

-(NSMutableArray *)facedUpCards
{
    if (!_facedUpCards) {
        _facedUpCards = [[NSMutableArray alloc] init];
    }
    return _facedUpCards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    self.cardMatchingLevel = 2;
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MATCH_BONUS 4 
#define MISMATCH_PENALTY 2

-(void) flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            self.flipDescription = [NSString stringWithFormat:@"Flipped up %@ !", card.contents];
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            //Checks if first two cards match when in three card match mode.
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    if ([card match:@[otherCard]]) {
                        [otherCards addObject:otherCard];
                    } else {
                        otherCard.faceUp = NO;
                        self.flipDescription = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                }
            }
            if ([otherCards count] == (self.cardMatchingLevel - 1) ) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    card.unplayable = YES;
                    self.flipDescription = [NSString stringWithFormat:@"%@ ", card.contents];
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                        self.flipDescription = [self.flipDescription stringByAppendingFormat:@"%@ ", otherCard.contents];
                        if (![otherCards lastObject]) {
                            self.flipDescription = [self.flipDescription stringByAppendingFormat:@"& "];
                        }
                    }
                    self.score += matchScore * MATCH_BONUS;
                    self.flipDescription = [self.flipDescription stringByAppendingFormat:@"match! Match Bonus!"];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}


@end
