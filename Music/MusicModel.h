//
//  MusicModel.h
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

//歌曲链接
@property (nonatomic,copy)NSString *mp3Url;
//id
@property (nonatomic,assign)NSInteger numberID;
//歌曲名
@property (nonatomic,copy)NSString *name;
//图片网址
@property (nonatomic,copy)NSString *picUrl;
//歌手
@property (nonatomic,copy)NSString *singer;
//歌词
@property (nonatomic,copy)NSString *lyric;
//时间
@property (nonatomic,copy)NSString *duration;


@end
