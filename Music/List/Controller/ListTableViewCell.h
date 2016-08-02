//
//  ListTableViewCell.h
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface ListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *musicImageView;

@property (strong, nonatomic) IBOutlet UILabel *musicNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *musicSingerLabel;


#pragma mark - cell的赋值方法
-(void)setCellDataWithMusicModel:(MusicModel *)model;


@end
