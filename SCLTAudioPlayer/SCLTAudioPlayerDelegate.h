//
//  SCLTAudioPlayerDelegate.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-04-05.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLTAudioPlayer.h"

@class SCLTMediaItem, SCLTAudioPlayer;

@protocol SCLTAudioPlayerDelegate <NSObject>

-(void)playerDidPlay:(SCLTAudioPlayer*)player;
-(void)playerDidPause:(SCLTAudioPlayer*)player;
-(void)player:(SCLTAudioPlayer*)player didAdvanceQueue:(SCLTMediaItem*)newItem;
-(void)player:(SCLTAudioPlayer*)player didReverseQueue:(SCLTMediaItem*)newItem;

@end
