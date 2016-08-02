//
//  PlayViewController.m
//  Music
//
//  Created by lanou3g on 15/12/9.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "PlayViewController.h"
#import "MusicTool.h"
#import "MusicModel.h"
#import "MusicDataManager.h"
#import "UIImageView+WebCache.h"
#import "LyricTableViewCell.h"
#import "TimeLyricModel.h"
typedef enum : NSUInteger {
    playingStatus=100,
    stopingStatus,
    nonStatus,
} musicStatus;

@interface PlayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *playAndStopButton;
//背景图片
@property (strong, nonatomic) IBOutlet UIImageView *background;
//音乐的播放进度条
@property (strong, nonatomic) IBOutlet UIProgressView *musicProgressView;
//音乐的总时间
@property (strong, nonatomic) IBOutlet UILabel *musicTimeLabel;
//歌词
@property (strong, nonatomic) IBOutlet UITableView *lyricTableView;
//歌词数组
@property (nonatomic,strong)NSArray *lyricArray;

//定义定时器
@property (nonatomic,strong)NSTimer *progressTimer;

//定义AVplayer 变量接收当前正在播放的player
@property (nonatomic,strong)AVPlayer *player;

//全局变量 记录当前播放歌词模型的下标
@property (nonatomic,assign)NSInteger currentLyricIndex;

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myImageView.layer.cornerRadius = 30;
    
    //注册音乐播放完毕的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

//    //定时器NSTimer:实现一定时间间隔重复执行某项任务
//    [NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> target:<#(nonnull id)#> selector:<#(nonnull SEL)#> userInfo:<#(nullable id)#> repeats:<#(BOOL)#>]
    
    
    
}
#pragma mark - 音乐播放完毕
-(void)musicDidPlayEnd:(NSNotification *)sender
{
    [self clickNextAction:nil];
}
#warning 注意
//注册通知也可以写在这
//在viewWillDisappear方法里移除通知
-(void)viewWillAppear:(BOOL)animated
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
//    //移除所有的通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //移除指定通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - 需要注意点(可能面试题)
-(void)dealloc
{
    //ARC下可以写dealloc方法,但不能写[super dealloc]
//    [super dealloc];
    
    //移除所有的通知
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除指定通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

#pragma mark - 设置row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LyricTableViewCell"];
    TimeLyricModel *model = self.lyricArray[indexPath.row];
    cell.lyricLabel.text = model.lyric;
    if (indexPath.row == self.currentLyricIndex) {
        cell.lyricLabel.textColor = [UIColor purpleColor];
    }else{
        cell.lyricLabel.textColor = [UIColor greenColor];
    }
    return cell;
}

#pragma mark - 弹出界面播放音乐
-(void)showViewAndPlayMusic
{
    //把控制器的view添加到window上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    //1.让view处于屏幕最下方
    self.view.y = window.height;
    window.userInteractionEnabled = NO;
    //2.通过动画让view处于屏幕上方
    [UIView animateWithDuration:0.5f animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //开启用户交互
        window.userInteractionEnabled = YES;
        //重置歌曲
        [self resetMusicInfo];
        self.playAndStopButton.tag = playingStatus;

    }];
    
    //打电话
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://11222"]];
//    //发短信
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://11222"]];
}
#pragma mark - 返回
- (IBAction)clickBackAction:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        [self.view removeFromSuperview];
    }];
    NSLog(@"返回");
}
//暂停当前音乐
-(void)pauseCurrentMusic
{
    //先暂停当前播放的歌曲
    MusicModel *current = [[MusicDataManager sharedDataManager] currentPlayMusic];
    [MusicTool stopMusicWithMusicUrlString:current.mp3Url];
    //从字典移除item
    [MusicTool removeCurrentItem:current.mp3Url];
}
#pragma mark - 重置歌曲信息
-(void)resetMusicInfo
{
    MusicModel *model = [[MusicDataManager sharedDataManager] currentPlayMusic];
    self.player = [MusicTool playerMusicWithMusicUrlString:model.mp3Url];
    //设置背景图片
    [self.background sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x.jpg"]];
    //设置总时间
    self.musicTimeLabel.text = model.duration;
    
    self.lyricArray = [[MusicDataManager sharedDataManager] getCurrentLyric];
    //刷新数据
    [self.lyricTableView reloadData];
    //只运行一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        //初始化定时器
        //时间不能小于0.1,如果说小于0.1,系统默认使用0.1
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateMusicProgress) userInfo:nil repeats:YES];
        //把timer加入到运行循环
        [[NSRunLoop currentRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
        //runLoop//
        //主线程的runloop默认是开启的,所以主线程永远不会结束
        //子线程的runloop默认是关闭的,所以只要子线程的任务完成之后,子线程就会销毁
        //

//    });
    //开启定时器
//    self.progressTimer.fireDate = [NSDate distantPast];
    
    
    if (self.playAndStopButton.tag == stopingStatus) {
        self.playAndStopButton.tag = playingStatus;
        [self.playAndStopButton setBackgroundImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateNormal];
    }
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x.jpg"]];
}

#pragma mark - 实现方法 updateMusicProgress(更新进度)
-(void)updateMusicProgress
{
   //数组里面 时间模型
    NSInteger currentTime = self.player.currentTime.value/self.player.currentTime.timescale;
    for (int i=0; i<self.lyricArray.count; i++) {
        TimeLyricModel *model = self.lyricArray[i];
        //判断当前时间 是否和模型表示的时间相同
        if (currentTime == model.time) {
            self.currentLyricIndex = i;
            break;
        }
    }
    //让tableView滑动到这一行
    [self.lyricTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLyricIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.lyricTableView reloadData];
    
    MusicModel *model = [[MusicDataManager sharedDataManager] currentPlayMusic];
    NSArray *timeArray = [model.duration componentsSeparatedByString:@":"];
    NSInteger sum = [timeArray[0] integerValue]*60 + [timeArray[1] integerValue];
    self.musicProgressView.progress = currentTime/(sum*1.0f);
    
//    if (self.playAndStopButton.tag == playingStatus) {
//        self.myImageView.transform = CGAffineTransformRotate(self.myImageView.transform, M_PI_2/10);
//    }
    
    if (self.playAndStopButton.tag == playingStatus) {
        [UIView animateWithDuration:3 animations:^{
            self.myImageView.transform = CGAffineTransformRotate(self.myImageView.transform, M_PI_2/5);
        }];
    }
    
//    [self.progressTimer invalidate];
}
#pragma mark - 上一曲
- (IBAction)clickPreviousAction:(id)sender {
    NSLog(@"上一曲");
    [self pauseCurrentMusic];
    //拿出需要播放的音乐模型
    MusicModel *model = [[MusicDataManager sharedDataManager] previousPlayMusic];

    //设置当前播放的模型
    [[MusicDataManager sharedDataManager] setCurrentPlayMusic:model];
    //重置歌曲信息
    [self resetMusicInfo];
    
    self.progressTimer.fireDate = [NSDate distantFuture];
}
#pragma mark - 暂停播放
- (IBAction)clickStopAction:(id)sender {
    NSLog(@"暂停播放");
    MusicModel *model = [[MusicDataManager sharedDataManager] currentPlayMusic];
    
    if (self.playAndStopButton.tag == playingStatus) {
        self.playAndStopButton.tag = stopingStatus;
        //修改Button的图片
        [self.playAndStopButton setBackgroundImage:[UIImage imageNamed:@"play@2x.png"] forState:UIControlStateNormal];
        //暂停音乐
        [MusicTool stopMusicWithMusicUrlString:model.mp3Url];
    }else{
        self.playAndStopButton.tag = playingStatus;
        [self.playAndStopButton setBackgroundImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateNormal];
        //播放音乐
        [MusicTool playerMusicWithMusicUrlString:model.mp3Url];
    }
}
#pragma mark - 下一曲
- (IBAction)clickNextAction:(id)sender {
    NSLog(@"下一曲");
    [self pauseCurrentMusic];
    //下一曲模型
    MusicModel *model = [[MusicDataManager sharedDataManager] nextPlayMusic];
    //获取当前播放模型
    [[MusicDataManager sharedDataManager] setCurrentPlayMusic:model];
    //重置
    [self resetMusicInfo];
    
    self.progressTimer.fireDate = [NSDate distantFuture];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
