//
//  SCLTAudioPlayer.m
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-03-30.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import "SCLTAudioPlayer.h"


@interface SCLTAudioPlayer()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) NSInteger currentIndex;

@end



@implementation SCLTAudioPlayer

+(SCLTAudioPlayer*)sharedPlayer {
    static dispatch_once_t onceToken;
    static SCLTAudioPlayer *sharedPlayer = nil;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [[SCLTAudioPlayer alloc] init];
    });
    return sharedPlayer;
}

-(instancetype) init {
    if (self = [super init]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}



#pragma mark - Player Controls

-(void)play {
    _isPlaying = YES;
    [self.player play];
    
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    [strongDelegate playerDidPlay:self];
}

-(void)pause {
    _isPlaying = NO;
    [self.player pause];
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    [strongDelegate playerDidPause:self];
}

-(void)togglePlayPause {
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

-(void)previous {
    [self reversePlaylist];
}

-(void)next {
    [self advancePlaylist];
}




#pragma mark - Playlist Management

-(void)playItem:(SCLTMediaItem*)item {
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:item.assetURL
                                                         error:&error];
    self.currentItem = item;
    
    if (error) {
        [self postNotification:SCLTAudioPlayerError];
        self.player = nil;
        return;
    }
    
    if (self.isPlaying) {
        [self play];
    }
    
    [self updateSystemControls];
}


-(void)advancePlaylist {
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    
    double time = self.player.currentTime / self.player.duration;
    [strongDelegate player:self willAdvancePlaylist:self.currentItem atPoint:time];
    
    self.currentIndex = self.currentIndex + 1;
    SCLTMediaItem *nextItem = self.playlist[self.currentIndex];
    [self playItem:nextItem];

    [strongDelegate player:self didAdvancePlaylist:nextItem];
}


-(void)reversePlaylist {
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    
    double time = self.player.currentTime / self.player.duration;
    [strongDelegate player:self willReversePlaylist:self.currentItem atPoint:time];
    
    self.currentIndex = self.currentIndex - 1;
    SCLTMediaItem *nextItem = self.playlist[self.currentIndex];
    [self playItem:nextItem];
    
    [strongDelegate player:self didReversePlaylist:nextItem];
}


-(void)setPlaylist:(NSArray *)playlist {
    _playlist = playlist;
    if ([playlist count] > 0) {
        self.currentItem = playlist[0];
        self.currentIndex = 0;
        
        [self playItem:self.currentItem];

        [self updateSystemControls];
    }
}


-(void)setCurrentIndex:(NSInteger)currentIndex {
    if (!self.playlist) {
        _currentIndex = 0;
        [self postNotification:SCLTAudioPlayerError];
        return;
    }
    
    if (currentIndex > [self.playlist count]) {
        _currentIndex = 0;
    } else if (currentIndex < 0) {
        _currentIndex = [self.playlist count];
    } else {
        _currentIndex = currentIndex;
    }
    
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self advancePlaylist];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [player pause];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        [player play];
    }
}


#pragma mark - System bindings

-(void)handleRemoteControlEvent:(UIEvent*)receivedEvent{
    if (receivedEvent.type == UIEventTypeRemoteControl){
        switch (receivedEvent.subtype){
            case UIEventSubtypeRemoteControlPause:
                [self pause];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self play];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self play];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previous];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self next];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                break;
            default:
                break;
        }
    }
}

-(void)updateSystemControls{

    if (!self.currentItem.mediaItem) {
        return;
    }
    
    MPMediaItem* currentItem = self.currentItem.mediaItem;
    NSDictionary *nowPlayingInfo = @{
                                     MPMediaItemPropertyTitle:[currentItem valueForKey:MPMediaItemPropertyTitle],
                                     MPMediaItemPropertyArtist:[currentItem valueForKey:MPMediaItemPropertyArtist],
                                     MPMediaItemPropertyArtwork:[currentItem valueForProperty:MPMediaItemPropertyArtwork],
                                     MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithDouble:self.player.duration],
                                     MPNowPlayingInfoPropertyElapsedPlaybackTime:[NSNumber numberWithDouble:self.player.currentTime],
                                     MPNowPlayingInfoPropertyPlaybackRate:@1.0
                                     
                                     };
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
}



#pragma mark - Util

-(void)postNotification:(NSString*)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification
                                                        object:self];
}



@end
