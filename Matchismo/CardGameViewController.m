//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kyle Adams on 6/12/13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreButton;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gameTypeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic, strong) NSMutableArray *actionsHistory;

@end

@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

-(NSMutableArray *)actionsHistory
{
    if (!_actionsHistory) _actionsHistory = [[NSMutableArray alloc] init];
    return _actionsHistory;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    UIImage *cardBackImage = [UIImage imageNamed:@"card-back.png"];
    UIImage *blank = [[UIImage alloc] init];
    
    for (UIButton *cardButton in cardButtons)
    {
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        [cardButton setImage:blank forState:UIControlStateSelected];
        [cardButton setImage:blank forState:UIControlStateSelected|UIControlStateDisabled];
    }
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
    }
    self.scoreButton.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = self.game.flipDescription;
}


- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
}

- (IBAction)flipCard:(UIButton *)sender {
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self.gameTypeSwitch setEnabled:NO];
    [self.actionsHistory addObject:self.game.flipDescription];
    self.historySlider.enabled = YES;
    self.historySlider.maximumValue = [self.actionsHistory count];
    [self.historySlider setValue:[self.actionsHistory count]];
    [self updateUI];
    self.flipCount++;
}

- (IBAction)flipDescriptionHistory:(UISlider *)sender {
    NSInteger historyIndex = roundl([sender value]);
    if (historyIndex == 0) {
        self.lastFlipLabel.text = [self.actionsHistory objectAtIndex:historyIndex];
    } else {
        self.lastFlipLabel.text = [self.actionsHistory objectAtIndex:historyIndex - 1];
    }
}

- (IBAction)gameTypeSet:(UISwitch *)sender {
    if (sender.isOn) {
         _game.cardMatchingLevel = 3;
    } else {
        _game.cardMatchingLevel = 2;
    }
    NSLog(@"Game type set to: %d", _game.cardMatchingLevel);
}


- (IBAction)resetGame:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    [self.actionsHistory removeAllObjects];
    self.historySlider.enabled = NO;
    self.historySlider.value = 0;
    [self.gameTypeSwitch setEnabled:YES];
    [self.gameTypeSwitch setOn:NO];
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.historySlider.enabled = NO;
    self.historySlider.value = 0;
    [self updateUI];
}

@end
