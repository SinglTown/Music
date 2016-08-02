//
//  ListViewController.m
//  Music
//
//  Created by lanou3g on 15/12/8.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "MusicDataManager.h"
#import "MusicModel.h"
#import "PlayViewController.h"
#import "MBProgressHUD.h"
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic,strong)PlayViewController *playVC;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    [self getDataFromNetWork];
    
    
    
}
-(void)getDataFromNetWork
{
    //转圈
    [MBProgressHUD showHUDAddedTo:self.mainTableView animated:YES];
    
    
    MusicDataManager *manager = [MusicDataManager sharedDataManager];
    //网络请求
    [manager getDataFromNetWorkWithBlock:^(BOOL isfinished) {
        [MBProgressHUD hideHUDForView:self.mainTableView animated:YES];
        if (isfinished == YES) {
            [self.mainTableView reloadData];
        }else{
            NSLog(@"网络请求失败");
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"网络请求失败,是否重新加载" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getDataFromNetWork];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            //弹框 -利用模态方法
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MusicDataManager sharedDataManager].dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell"];
    MusicModel *model = [MusicDataManager sharedDataManager].dataArray[indexPath.row];
    [cell setCellDataWithMusicModel:model];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark - cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取storyboard上面的控制器(不能直接用alloc..init的方法,storyBoard本身有视图控制器,用初始化后,会变成一个新的控制器,跟原来的颜色不同)
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.playVC = [board instantiateViewControllerWithIdentifier:@"PlayViewController"];//(如果写成 PlayViewController *VC = [board instantiateViewControllerWithIdentifier:@"PlayViewController"]会造成控制器过早释放)
    MusicDataManager *manager = [MusicDataManager sharedDataManager];
    [manager setCurrentPlayMusic:manager.dataArray[indexPath.row]];
    [self.playVC showViewAndPlayMusic];
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
