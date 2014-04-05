//
//  SCLTAudioPlayer.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-03-30.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SCLTAudioPlayerDelegate.h"
#import "SCLTMediaItem.h"
#import "SCLTAudioPlayerNotifications.h"

@interface SCLTAudioPlayer : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, weak) id<SCLTAudioPlayerDelegate> delegate;
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) SCLTMediaItem *currentItem;
@property (nonatomic, assign, readonly) BOOL isPlaying;

+(SCLTAudioPlayer*)sharedPlayer;

-(void)play;
-(void)pause;
-(void)togglePlayPause;
-(void)previous;
-(void)next;

-(void)handleRemoteControlEvent:(UIEvent*)receivedEvent;

@end
