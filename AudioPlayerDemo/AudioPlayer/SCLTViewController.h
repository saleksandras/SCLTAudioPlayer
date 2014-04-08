//
//  SCLTViewController.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-03-30.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SCLTAudioPlayer.h"

@interface SCLTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SCLTAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *songTableView;

@property (strong, nonatomic) IBOutlet UIButton *buttonPlay;
- (IBAction)handleButtonPlay:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonBack;
- (IBAction)handleButtonBack:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIButton *buttonNext;
- (IBAction)handleButtonNext:(UIButton *)sender;



@end
