SCLTAudioPlayer
===============

SCLTAudioPlayer is the playback the core of [ShufflePlus](http://scarlet.io). It's an extension of [AVAudioPlayer](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVAudioPlayerClassReference/Chapters/Reference.html) and is intended to simplify the process of playing audio. It is primarily intended for playing audio from the local media library, but is also capable of playing remote assets. 

SCLTAudioPlayer requires iOS 7.0 or greater. 

Installation
------------

SCLTAudioPlayer is easiest installed with [CocoaPods](http://cocoapods.org/). Just add this to your podfile: 

```ruby 
platform :ios, '7.0'
pod "SCLTAudioPlayer", "~> 0.1.0"
```

Getting Started
---------------

As a basic example, here's how to play a single track from the media library: 

```objc
// Fetch a list of all the songs on a device
MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
self.songs = [songsQuery items]; 

// We want to play the first one
MPMediaItem *song = self.songs[0];

// Play it!
SCLTMediaItem *mediaItem = [[SCLTMediaItem alloc] initWithMediaItem:song];
[[SCLTAudioPlayer sharedPlayer] setPlaylist:@[mediaItem]];
[[SCLTAudioPlayer sharedPlayer] play];
```

Background Support
------------------

SCLTAudioPlayer also supports background playback, and responds to remote control events. You can also execute arbitrary code in the background on a number of different events by registering a delegate with the player. 

To set up background playback, you'll need to add some code to your app delegate:

```objc
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent*)receivedEvent{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        [[SCLTAudioPlayer sharedPlayer] handleRemoteControlEvent:receivedEvent];
    }
}
```

You'll of course also need to enable background audio in the Capabilities tab of your app settings:

![Enabling background audio in Xcode](http://i.imgur.com/FhGtWfL.png)


