//
//  MusicModel.m
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.numberID = [value integerValue];
    }
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"duration"]) {
        NSInteger sumSeconds = [value integerValue]/1000;
        self.duration = [NSString stringWithFormat:@"%ld:%ld",sumSeconds/60,sumSeconds%60];
    }
}

@end
