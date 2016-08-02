//
//  TimeLyricModel.m
//  Music
//
//  Created by lanou3g on 15/12/9.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "TimeLyricModel.h"

@implementation TimeLyricModel

#pragma mark - 自定义初始化方法
-(instancetype)initWithTime:(NSInteger)time
                  withLyric:(NSString *)lyric
{
    self = [super init];
    if (self) {
        self.time = time;
        self.lyric = lyric;
    }
    return self;
}


@end
