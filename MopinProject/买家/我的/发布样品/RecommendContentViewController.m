//
//  RecommendContentViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/29.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "RecommendContentViewController.h"
#import "RecommendContentCell.h"
#import "RecommendContentModel.h"

@interface RecommendContentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RecommendContentCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    UITextField *_textField;
    UIView *_footerView; //tableView底部视图
    BOOL _isInput; //判断是否正在输入
    UIButton *_sureButton; //确定按钮
}
@end

@implementation RecommendContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"推荐内容";
    [self setNavBackBtnWithType:1];
    
    [self createBottomButton];
    _dataArr=[NSMutableArray arrayWithArray:_RCArr];
    
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide) name:UIKeyboardWillHideNotification object:nil];
}
//TODO:创建底部确定按钮
- (void)createBottomButton
{
    _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth, mTabBarHeight);
    _sureButton.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [self.view addSubview:_sureButton];
    
    [_sureButton addTarget:self action:@selector(sureButoonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//TODO:点击确定
- (void)sureButoonClick
{
    if(_dataArr.count==0 && _textField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入您推荐的内容"];
        return;
    }else if (_dataArr.count!=0 && _textField.text.length==0){
        self.GetrecommendContent(_dataArr);
        [self backBtnClick];
        return;
    }
    [self addContent:_sureButton];
}
//TODO:键盘显示
- (void)keybordShow:(NSNotification *)notification
{
    _isInput=YES;
    //获取键盘高度
    NSDictionary *info=[notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    _tableView.frame=CGRectMake(0,0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-kbHeight);

    CGFloat offSetY=_tableView.contentSize.height-_tableView.frame.size.height;
    offSetY=offSetY<=0?0:offSetY+105;
    [_tableView scrollRectToVisible:CGRectMake(0, offSetY, kkDeviceWidth, _tableView.frame.size.height) animated:YES];

//    _kbHeight=kbHeight;
////    CGRect rect=[_tableView rectForFooterInSection:0];
////    CGRect =[_tableView rectForFooterInSection:0];
//    CGFloat y;
//    if(offSetY==0){
//        
////        y=rect.origin.y-(kkDeviceHeight-105-_kbHeight-mNavBarHeight);
//    }else{
////        y=rect.origin.y-(kkDeviceHeight-105-_kbHeight-mNavBarHeight)-offSetY;
//    }
//    //获取输入框相对位置
////    CGFloat y=rect.origin.y-(kkDeviceHeight-105-kbHeight-mNavBarHeight);
//    if(y<=0){
//        return;
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        _tableView.frame=CGRectMake(0,y>=kbHeight?-kbHeight:-y, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
//    }];
}
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    
}
//TODO:添加内容
- (void)addContent:(UIButton *)button
{
    
    if(_textField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入您推荐的内容"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_textField.text]){
        [SVProgressHUD showErrorWithStatus:@"推荐内容不能全为空格"];
        return;
    }
    if(_textField.text.length>SAMPLE_RECOMMEND_LENGTH){
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"推荐内容不能超过%@个",@(SAMPLE_RECOMMEND_LENGTH)]];
        return;
    }
    
    NSString *content=_textField.text;
    button.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"AddRecommendContent" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:content forKey:@"RecommendContent"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        button.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
    
            RecommendContentModel *model=[[RecommendContentModel alloc]init];
            model.RCID=jsonObject[@"data"][@"RCID"];
            model.RCContent=content;
            [_dataArr addObject:model];
            
            _textField.text=nil;
            
            if(button==_sureButton){
                [_textField resignFirstResponder];
                self.GetrecommendContent(_dataArr);
                [self backBtnClick];
            }
        }
        if(button!=_sureButton){
            [_tableView reloadData];
        }
        
        
        //移动tableView的位置
//        if([_textField isFirstResponder]){
//            CGFloat offSetY=_tableView.contentSize.height-_tableView.frame.size.height;
//            offSetY=offSetY<=0?0:offSetY;
//           [_tableView scrollRectToVisible:CGRectMake(0,offSetY+105, kkDeviceWidth, _tableView.frame.size.height) animated:YES];
//            CGRect rect=[_tableView rectForFooterInSection:0];
//            CGFloat y;
//            if(offSetY==0){
////                y=rect.origin.y-(kkDeviceHeight-105-_kbHeight-mNavBarHeight);
//            }else{
////                y=rect.origin.y-(kkDeviceHeight-105-_kbHeight-mNavBarHeight)-offSetY;
//            }
//            
//            
//            if(y>0){
//                [UIView animateWithDuration:0.3 animations:^{
//                    _tableView.frame=CGRectMake(0,y>=_kbHeight?-_kbHeight:-y, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
//                }];
//            }
//        }
    } failure:^(NSError *error){
        button.userInteractionEnabled=YES;
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
#pragma mark - RecommendContentCell delegate
- (void)deleteRecommendContent:(RecommendContentModel *)model
{
    [_dataArr removeObject:model];
    [_tableView reloadData];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
    }];
    return YES;
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 105.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendContentCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"RecommendContentCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RecommendContentCell" owner:self options:nil]firstObject];
    }
    RecommendContentModel *model=_dataArr[indexPath.row];
    cell.model=model;
    cell.delegate=self;
    [cell reloadCell];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_footerView){
        [_textField becomeFirstResponder];
        
        return _footerView;
    }
    _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 105)];
    _footerView.backgroundColor=self.view.backgroundColor;
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kkDeviceWidth, 45)];
    bgView.backgroundColor=[UIColor whiteColor];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kkDeviceWidth-60, 45)];
    _textField.delegate=self;
    _textField.placeholder=@"请输入您推荐的内容";
    _textField.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:_textField];
    [_footerView addSubview:bgView];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加内容" forState:UIControlStateNormal];
    addButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"plus_sample.png"] forState:UIControlStateNormal];
    addButton.frame=CGRectMake(0, 55,140, 50);
    addButton.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    addButton.imageEdgeInsets=UIEdgeInsetsMake(0, -5, 0, 0);
    
    [addButton addTarget:self action:@selector(addContent:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:addButton];
    
    return _footerView;
}
//TODO:让tableView的分割线从头开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
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
