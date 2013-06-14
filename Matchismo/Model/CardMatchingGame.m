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
@property (nonatomic) int score;
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
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MATCH_BONUS 4 
#define MISMATCH_PENALTY 2

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.faceUp) {
            for (Card *othercard in self.cards) {
                if (othercard.isFaceUp && !othercard.isUnplayable) {
                    int matchScore = [card match:@[othercard]];
                    if (matchScore) {
                        othercard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    } else {
                        othercard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}




@end
