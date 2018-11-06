//
//  CommentListController.m
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CommentListController.h"
#import "UserCommentCell.h"
#import "ReplyCommentViewController.h"

@interface CommentListController () {
    UITableView *_tableView;
    PersonalInfoSingleModel *_personalModel;
}

@end

@implementation CommentListController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNavBackBtnWithType:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    
    //监听跳转到哪个控制器的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommentButtonActionNotification:) name:@"CommentButtonActionNotification" object:nil];
}



//TODO:创建Tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    [self requestCommentList];
}


//TODO:通知：监听按钮
- (void)CommentButtonActionNotification:(NSNotification*)notification {
    NSString *buttonId = notification.userInfo[@"buttonTag"];
    if ([buttonId isEqual:@"300"]) {  //回复
        ReplyCommentViewController *replayCommentVC =  [[ReplyCommentViewController alloc] init];
        replayCommentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:replayCommentVC animated:YES];
    }else {
        [self requestToTop];
    }
}

//TODO:请求评价列表数据
- (void)requestCommentList {
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCommentList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:@"0" forKey:@"TagID"];
    [parameterDic setValue:@"1" forKey:@"SelectState"];
    [parameterDic setValue:@"1" forKey:@"PageIndex"];
    [parameterDic setValue:@"10" forKey:@"PageSize"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        NSArray *data = jsonObject[@"data"];
        if (code.integerValue == 1000) {
            NSLog(@"%@",jsonObject);
            [data enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                
            }];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        
    }];
}


//TODO:置顶接口
- (void)requestToTop {
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CommentTop" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    //缺少订单ID
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        NSArray *data = jsonObject[@"data"];
        if (code.integerValue == 1000) {
            NSLog(@"%@",jsonObject);
            [data enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                
            }];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        
    }];
}


//TODO:UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     UserCommentCell *cell = [[UserCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
     return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tableView.height/2;
}





@end
