//
//  CRSecondViewController.m
//  LoggerExample
//
//  Created by Karthik Saligrama on 8/13/14.
//
//

#import "CRSecondViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <LoggerFramework/Logger.h>

@interface CRSecondViewController (){
    UIButton *playButton;
    AVPlayerItem *playerItem;
    AVPlayer *player;
    UIButton *killApp;
}

@end

@implementation CRSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =  @"Second Screen";
    
    playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playButton setTitle:@"Play Audio" forState:UIControlStateNormal];
    
    [playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [playButton sizeToFit];
    
    CGRect frame = playButton.frame;
    frame.origin.x = self.view.bounds.size.width/2-frame.size.width/2;
    frame.origin.y =self.view.bounds.size.height/2-frame.size.height/2;
    playButton.frame = frame;
    [self.view addSubview:playButton];
    
    killApp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [killApp setTitle:@"Kill App" forState:UIControlStateNormal];
    [killApp addTarget:self action:@selector(dieNow) forControlEvents:UIControlEventTouchUpInside];
    [killApp sizeToFit];
    
    CGRect killFrame = killApp.frame;
    killFrame.origin.y = playButton.frame.origin.y + playButton.frame.size.height + 10;
    killFrame.origin.x = playButton.frame.origin.x;
    killApp.frame = killFrame;
    [self.view addSubview:killApp];
}

-(void)dieNow{
    [CRUtilities crash];
}


-(void)playAudio:(id)sender{
    NSURL *audioUrl = [NSURL URLWithString:AUDIO_TEST_URL];
    playerItem = [AVPlayerItem playerItemWithURL:audioUrl];
    
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [player cancelPendingPrerolls];
    player = nil;
    playerItem = nil;
}

@end
