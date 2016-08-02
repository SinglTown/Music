//
//  MusicDataManager.m
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "MusicDataManager.h"
#import "MusicModel.h"
#import "TimeLyricModel.h"
@interface MusicDataManager ()

{
    MusicModel *_currentPlayModel;
}

@end
static MusicDataManager *dataManager = nil;

@implementation MusicDataManager

+(instancetype)sharedDataManager
{
    
    return [[self alloc] init];
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone//zone,为了解决内存碎片的问题
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataManager == nil) {
            dataManager = [super allocWithZone:zone];
        }
    });
    return dataManager;
}

-(void)getDataFromNetWorkWithBlock:(NETWORKBLOCK)finishBlock
{
    NSString *urlString = @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist";
    NSURL *url = [NSURL URLWithString:urlString];
    //创建一个全局队列,队列里的任务都是在子线程里面去执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //在子线程要自己写@autoreleasepool,否则会内存泄露
    dispatch_async(queue, ^{
        @autoreleasepool {
            NSArray *array = [NSArray arrayWithContentsOfURL:url];
            NSMutableArray *tempMutableArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                MusicModel *model = [[MusicModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [tempMutableArray addObject:model];
            }
            self.dataArray = [NSArray arrayWithArray:tempMutableArray];
//            [self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>]
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataArray.count > 0) {
                    finishBlock(YES);
                }else{
                    finishBlock(NO);
                }
            });
        }
    });
}

//获取当前应该播放的歌曲
-(MusicModel *)currentPlayMusic
{
    return _currentPlayModel;
}
//设置当前歌曲的方法
-(void)setCurrentPlayMusic:(MusicModel *)model
{
    //如果设置的音乐存在于列表当中
    if ([self.dataArray containsObject:model]) {
        _currentPlayModel = model;
    }
}
//获取上一曲
-(MusicModel *)previousPlayMusic
{
    NSInteger index = [self.dataArray indexOfObject:_currentPlayModel];
    if (index == 0) {
        _currentPlayModel = self.dataArray.lastObject;
        return self.dataArray.lastObject;
    }
    index = index-1;
    _currentPlayModel = self.dataArray[index];
    return self.dataArray[index];
}
//获取下一曲
-(MusicModel *)nextPlayMusic
{
    NSInteger index = [self.dataArray indexOfObject:_currentPlayModel];
    if (index == self.dataArray.count-1) {
        _currentPlayModel = self.dataArray.firstObject;
        return self.dataArray.firstObject;
    }
    index++;
    _currentPlayModel = self.dataArray[index];
    return self.dataArray[index];
}
#pragma mark - 获取当前播放歌曲的歌词数组
-(NSArray *)getCurrentLyric
{
    NSMutableArray *finalArray = [NSMutableArray array];
    NSString *lyricString = _currentPlayModel.lyric;
    NSArray *sumLyricArray = [lyricString componentsSeparatedByString:@"\n"];
    //循环遍历装有所有歌词的数组
    for (int i=0; i<sumLyricArray.count-1; i++) {
        NSString *lineLyricString = sumLyricArray[i];
        if (![lineLyricString hasPrefix:@"["]) {
            TimeLyricModel *model = [[TimeLyricModel alloc] initWithTime:0 withLyric:lineLyricString];
            [finalArray addObject:model];
            continue;
        }
        //根据']'切割
        NSArray *timeLyricArray = [lineLyricString componentsSeparatedByString:@"]"];
        //拿出时间字符串
        NSString *timeString = [timeLyricArray[0] substringWithRange:NSMakeRange(1, 5)];
        //根据':'切割出时间的分钟和秒
        NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
        //时间
        NSInteger time = [timeArray[0] integerValue]*60+[timeArray[1] integerValue];
        //取出歌词
        NSString *lyric = timeLyricArray[1];
        if (lyric.length < 1) {
            continue;
        }
        TimeLyricModel *model = [[TimeLyricModel alloc] initWithTime:time withLyric:lyric];
        [finalArray addObject:model];
    }
    return finalArray;
}
@end
