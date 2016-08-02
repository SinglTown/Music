//
//  TimeLyricModel.h
//  Music
//
//  Created by lanou3g on 15/12/9.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLyricModel : NSObject

//时间(以秒为单位)
@property (nonatomic,assign)NSInteger time;
//歌词
@property (nonatomic,copy)NSString *lyric;


#pragma mark - 自定义初始化方法
-(instancetype)initWithTime:(NSInteger)time
                  withLyric:(NSString *)lyric;

@end
