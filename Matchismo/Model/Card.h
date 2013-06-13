//
//  Card.h
//  Matchismo
//
//  Created by Kyle Adams on 6/12/13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong) NSString *contents;

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
