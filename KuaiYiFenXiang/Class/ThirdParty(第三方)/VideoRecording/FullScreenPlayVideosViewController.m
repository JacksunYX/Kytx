//
//  PlayVideoViewController.m
//  VideoRecord
//
//  Created by guimingsu on 15/4/27.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "FullScreenPlayVideosViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface FullScreenPlayVideosViewController ()<UITextFieldDelegate>

@end

@implementation FullScreenPlayVideosViewController
{
    
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    AVPlayerItem *playerItem;
    
    UIImageView* playImg;
    
    
    UIButton *collectbtn;
    
    
    
}

@synthesize videoURL;




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    
    
    NSLog(@"%@",self.videoURL);
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [self.view addGestureRecognizer:playTap];
    
    [self pressPlayButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    playImg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [playImg setImage:[UIImage imageNamed:@"playvideo"]];
    [playerLayer addSublayer:playImg.layer];
    playImg.hidden = YES;
    
    
    
    
    UIView *videoheadview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 60)];
    [videoheadview  setBackgroundColor:[UIColor colorWithRed:122.0f/255.0f green:118.0f/255.0f blue:253.0f/255.0f alpha:0.6f]];
    [self.view  addSubview:videoheadview];
    
    
    UIButton *backbtn=[[UIButton alloc]init];
    [backbtn setImage:[UIImage imageNamed:@"BACK"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"BACK"] forState:UIControlStateSelected];
    [backbtn addTarget:self action:@selector(backbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [videoheadview   addSubview:backbtn];
    backbtn.sd_layout
    .leftSpaceToView(videoheadview, 10)
    .centerYEqualToView(videoheadview)
    .widthIs(40)
    .heightIs(40);
    
    
    
    
    collectbtn=[[UIButton alloc]init];
    [collectbtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [collectbtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateSelected];
    [collectbtn addTarget:self action:@selector(collectbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectbtn   setSelected:NO];
    [videoheadview   addSubview:collectbtn];
    collectbtn.sd_layout
    .leftSpaceToView(backbtn, 60)
    .centerYEqualToView(videoheadview)
    .widthIs(40)
    .heightIs(40);
    
    
    
    UIButton *sharebtn=[[UIButton alloc]init];
    [sharebtn setImage:[UIImage imageNamed:@"sharebtnimage"] forState:UIControlStateNormal];
    [sharebtn setImage:[UIImage imageNamed:@"sharebtnimage"] forState:UIControlStateSelected];
    [sharebtn addTarget:self action:@selector(sharebtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [videoheadview   addSubview:sharebtn];
    sharebtn.sd_layout
    .leftSpaceToView(collectbtn, 30)
    .centerYEqualToView(videoheadview)
    .widthIs(40)
    .heightIs(40);
    
    
    
    
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



-(void)backbtnClick:(UIButton *)sender
{
    
    [self.navigationController  popViewControllerAnimated:YES];
    
}

-(void)collectbtnClick:(UIButton *)sender
{
    
    
    [self givelike:@""];
    
    
    
    
}

-(void)sharebtnClick:(UIButton *)sender
{
    
    
}





-(void)givelike:(NSString *)likestring{
    
    
    
    
    
    
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    
    [dic   setObject:[USER_DEFAULT  objectForKey:@"token"] forKey:@"token"];
    
    [dic   setObject:self.videoid forKey:@"vid_id"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(dianzan) parameters:dic isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO success:^(id responseObject)  {
                           
                           NSString *staStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]]; ;
                           
                           if (staStr.intValue==200) {
                               
                               [collectbtn setSelected:YES];
                               
                            }
                               
                               
                           
                           
                       } failure:^(NSError *error) {
                           
                           
                       } RefreshAction:^{
                           
                           
                       }];
    
    
    
    
    
    
    
}





-(BOOL)prefersStatusBarHidden

{
    
    return YES;// 返回YES表示隐藏，返回NO表示显示
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
