//
//  MusicDataManager.h
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;
@class TimeLyricModel;
typedef void(^NETWORKBLOCK)(BOOL isfinished);

@interface MusicDataManager : NSObject

//存储music数据
@property (nonatomic,strong)NSArray *dataArray;
////存储歌词模型的数组
//@property (nonatomic,strong)NSArray *lyricArray;

+(instancetype)sharedDataManager;


//网络请求
-(void)getDataFromNetWorkWithBlock:(NETWORKBLOCK)finishBlock;

//获取当前应该播放的歌曲
-(MusicModel *)currentPlayMusic;
//设置当前歌曲的方法
-(void)setCurrentPlayMusic:(MusicModel *)model;
//获取上一曲
-(MusicModel *)previousPlayMusic;
//获取下一曲
-(MusicModel *)nextPlayMusic;

#pragma mark - 获取当前播放歌曲的歌词数组
-(NSArray *)getCurrentLyric;



@end
