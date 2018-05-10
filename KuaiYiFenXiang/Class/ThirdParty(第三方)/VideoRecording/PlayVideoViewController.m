//
//  PlayVideoViewController.m
//  VideoRecord
//
//  Created by guimingsu on 15/4/27.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface PlayVideoViewController ()<UITextFieldDelegate>

@end

@implementation PlayVideoViewController
{

    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    AVPlayerItem *playerItem;
    
    UIImageView* playImg;
    
}

@synthesize videoURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.title = @"预览";
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(nextClick) image:@"" hightimage:@"" andTitle:@"下一步"];


    //创建播放视图
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    
    
    //页面上添加暂停播放手势
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [self.view addGestureRecognizer:playTap];
    [self pressPlayButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    //添加比方按钮
    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    playImg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [playImg setImage:[UIImage imageNamed:@"videoPlay"]];
    [playerLayer addSublayer:playImg.layer];
    playImg.hidden = YES;
    
}

-(void)playOrPause{
    if (playImg.isHidden) {
        playImg.hidden = NO;
        [player pause];
        
    }else{
        playImg.hidden = YES;
        [player play];
    }
}

- (void)pressPlayButton
{
    [playerItem seekToTime:kCMTimeZero];
    [player play];
}

- (void)playingEnd:(NSNotification *)notification
{
    if (playImg.isHidden) {
        [self pressPlayButton];
    }
}



-(void)nextClick{
    
    
    
    
       
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
