//
//  MusicTool.h
//  Music
//
//  Created by lanou3g on 15/12/9.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicTool : NSObject

//播放音乐
//AVPlay 比较强大,可以播放多媒体(支持在线播放)
//AVAudioPlayer 支持播放本地音乐(优点是:封装的比较好,用起来特别简单)

//音乐的播放
+(AVPlayer *)playerMusicWithMusicUrlString:(NSString *)urlString;
//音乐的暂停
+(AVPlayer *)stopMusicWithMusicUrlString:(NSString *)urlString;

//移除当前播放的item
+(void)removeCurrentItem:(NSString *)urlString;

@end
