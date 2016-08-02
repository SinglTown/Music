//
//  ListTableViewCell.m
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
@implementation ListTableViewCell

#pragma mark - cell的赋值方法
-(void)setCellDataWithMusicModel:(MusicModel *)model
{
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"loading_1@2x.png"]];
    self.musicNameLabel.text = model.name;
    self.musicSingerLabel.text = model.singer;
}



#pragma mark - 这个方法相当于代码的init方法
- (void)awakeFromNib {
    self.musicImageView.layer.cornerRadius = 50;
//    self.musicImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
