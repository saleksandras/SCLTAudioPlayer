//
//  SCLTViewController.m
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-03-30.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import "SCLTViewController.h"


@interface SCLTViewController ()

@property (nonatomic, strong) NSArray* songs;

@end

@implementation SCLTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // cache playlists
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    self.songs = [songsQuery items];
    
    [SCLTAudioPlayer sharedPlayer].delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updatePlayButtonLabel];
    [self updateTrackInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleButtonPlay:(UIButton *)sender {
    [[SCLTAudioPlayer sharedPlayer] togglePlayPause];
}

- (IBAction)handleButtonBack:(UIButton *)sender {
    [[SCLTAudioPlayer sharedPlayer] previous];
}

- (IBAction)handleButtonNext:(UIButton *)sender {
    [[SCLTAudioPlayer sharedPlayer] next];
}


-(void)updatePlayButtonLabel {
    if ([[SCLTAudioPlayer sharedPlayer] isPlaying]) {
        [self.buttonPlay setTitle:@"Pause" forState:UIControlStateNormal];
        [self.buttonPlay setTitle:@"Pause" forState:UIControlStateHighlighted];
    } else {
        [self.buttonPlay setTitle:@"Play" forState:UIControlStateNormal];
        [self.buttonPlay setTitle:@"Play" forState:UIControlStateHighlighted];
    }
}

-(void)updateTrackInfo {
    SCLTMediaItem *currentItem = [SCLTAudioPlayer sharedPlayer].currentItem;
    if (currentItem) {
        if (currentItem.mediaItem) {
            self.labelArtist.text = [currentItem.mediaItem valueForKey:MPMediaItemPropertyArtist];
            self.labelSongTitle.text = [currentItem.mediaItem valueForKey:MPMediaItemPropertyTitle];
        }
    }
}

#pragma mark - Audio Player delegate


-(void)playerDidPlay:(SCLTAudioPlayer *)player {
    [self updatePlayButtonLabel];
    [self updateTrackInfo];
}

-(void)playerDidPause:(SCLTAudioPlayer *)player {
    [self updatePlayButtonLabel];
}

-(void)player:(SCLTAudioPlayer *)player willAdvancePlaylist:(SCLTMediaItem *)currentItem atPoint:(double)normalizedTime {
    NSLog(@"Skipping to next item, at %.2f percent", normalizedTime*100);
}

-(void)player:(SCLTAudioPlayer *)player didAdvancePlaylist:(SCLTMediaItem *)newItem {
    NSLog(@"Next item playing!");
    [self updateTrackInfo];
}

-(void)player:(SCLTAudioPlayer *)player didReversePlaylist:(SCLTMediaItem *)newItem {
    NSLog(@"Previous item playing!");
    [self updateTrackInfo];
}

-(void)player:(SCLTAudioPlayer *)player willReversePlaylist:(SCLTMediaItem *)currentItem atPoint:(double)normalizedTime {
    NSLog(@"Skipping to last item, at %.2f percent", normalizedTime*100);
}




#pragma mark - Table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SONG" forIndexPath:indexPath];
    
    MPMediaItem *song  = self.songs[indexPath.row];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
    cell.textLabel.text = [song valueForProperty:MPMediaItemPropertyAlbumArtist];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *playlist = [NSMutableArray arrayWithCapacity:([self.songs count] - indexPath.row)];

    for (NSInteger i = indexPath.row; i < [self.songs count]; i++) {
    
        MPMediaItem *song = self.songs[i];

        SCLTMediaItem *smi = [[SCLTMediaItem alloc] initWithMediaItem:song];
        [playlist addObject:smi];
    }
    
    [[SCLTAudioPlayer sharedPlayer] setPlaylist:playlist];
    [[SCLTAudioPlayer sharedPlayer] play];
}


@end
