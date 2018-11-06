//
//  CustomCommentVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/13.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CustomCommentVC.h"
#import "XHDHelper.h"
#import "CommetListCell.h"
#import "PublishCommentVC.h"
#import "DWTagList.h"
#import "CommentListMod.h"
#import  "CommonEmptyTableBgView.h"
#import "AllSampleCommentCell.h"

#define kPageSize  @"10"

#define kkTestImgURL @"http://image.baidu.com/search/detail"

@interface CommentTagMod :NSObject

@property(nonatomic,strong)NSString *TagID;	//	评价标签ID
@property(nonatomic,strong)NSString *Title;	//	标签内容
@property(nonatomic,strong)NSString *TagNum;	//	评价数量

@end
@implementation CommentTagMod
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end


#pragma mark -- 控制器
static NSString *reuseName = @"CommetListCell";
@interface CustomCommentVC ()<UITableViewDataSource,UITableViewDelegate,ChooseTagDelegate>

@end

@implementation CustomCommentVC
{
    DWTagList *tagListView;   //标签视图
    NSMutableArray *tagDataArr; //标签数组
    
    UITableView*commentListTab; //回复列表
    NSMutableArray *dataArr; //数据源
    NSInteger _selectIndex;  //分类标签
    CommonEmptyTableBgView *comTabBg; //空载页
}

- (instancetype)initWithType:(NSInteger)type AndTypeID:(NSString*)typeID;
{
    self = [super init];
    if (self) {
        
        _type = type;  //类型
        _typeID = typeID; //ID
        _selectIndex = 0; //默认标签
        
        dataArr = [[NSMutableArray alloc]init];
        tagDataArr = [[NSMutableArray alloc]init];
        
        
        [self requestTagData];
        
        page = 1;
        [self requestTableDataWithTag:_selectIndex];//默认为0，请求全部的
    }
    return self;
}

#pragma mark -- 请求网络
/*获取评价标签的请求*/
- (void)requestTagData
{
    /*如果有数据则显示全部*/
    CommentTagMod *mod = [[CommentTagMod alloc]init];
    mod.TagID = 0;
    mod.TagNum = [NSString stringWithFormat:@"%ld",dataArr.count];
    mod.Title = @"全部";
    [tagDataArr insertObject:mod atIndex:0];
    [self updateHeaderView];
    
    
    [SVProgressHUD showWithStatus:@"正在努力加载中..."];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetUsedTagList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    /* 获取书家的评价列表：传书家ID获取样品的评价列表：传样品ID*/
    [parameterDic setValue:_typeID forKey:@"ID"];
    /*ID类型标记 0：书家ID 1：样品ID */
    [parameterDic setValue:[NSString stringWithFormat:@"%ld",_type] forKey:@"IDType"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000)
        {
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                CommentTagMod * mod = [[CommentTagMod alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                [tagDataArr addObject:mod];
            }
            [self updateHeaderView];
        }
    
    } failure:^(NSError *error)
     {
         [SVProgressHUD dismiss];
         NSLog(@"%@",error);
         
     }];


}
/*评价列表网络请求*/
- (void)requestTableDataWithTag:(NSInteger)tagID
{
    [SVProgressHUD showWithStatus:@"正在努力加载中..."];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCommentList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    //书家模式：传书家ID
    //用户模式获取书家的评价列表：传书家ID用户模式获取样品的评价列表：传样品ID
    [parameterDic setValue:_typeID forKey:@"ID"];
    [parameterDic setValue:[NSString stringWithFormat:@"%ld",_type] forKey:@"IDType"];//ID类型标记 0：书家ID 1：样品ID
    [parameterDic setValue:[NSString stringWithFormat:@"%ld",tagID] forKey:@"TagID"];//标签ID  0：标识全部 (书家模式默认传0)  非0：按照标签筛选
    [parameterDic setValue:[NSString stringWithFormat:@"%d",page] forKey:@"PageIndex"]; //当前页数
    [parameterDic setValue:@"5" forKey:@"PageSize"];//返回数据条数
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [SVProgressHUD dismiss];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        [commentListTab headerEndRefreshing];
        [commentListTab footerEndRefreshing];
        if(page==1)
        {
            [dataArr removeAllObjects];
        }
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                CommentListMod *mod = [[CommentListMod alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                [dataArr addObject:mod];
            }
            [commentListTab reloadData];
        }
        if(_selectIndex==0)
        {
            /*更新全部标签的数目*/
            CommentTagMod *mod = [tagDataArr objectAtIndex:0];
            mod.TagNum = [NSString stringWithFormat:@"%ld",dataArr.count];
            [tagDataArr replaceObjectAtIndex:0 withObject:mod];
            [self updateHeaderView];
        }
        comTabBg.hidden = dataArr.count>0?YES:NO;
        
    } failure:^(NSError *error)
    {
        [commentListTab  headerEndRefreshing];
        [commentListTab  footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self requestTableDataWithTag:_selectIndex];
}
//TODO:加载更多
- (void)loadMoreData
{
    [self requestTableDataWithTag:_selectIndex];
}


#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_type==0){
        self.navigationItem.title=@"所有评价";
    }else{
        self.navigationItem.title=@"买家评价";
    }
    [self setNavBackBtnWithType:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeaderVeiw];
    [self createTableView];
}

#pragma mark -- 创建段头列表
- (void)createHeaderVeiw
{
    tagListView = [[DWTagList alloc] initWithFrame:mRect(0, 0, kkDeviceWidth, 105)];
    tagListView.chooseTagDelegate = self;
    [tagListView setTags:nil];
    tagListView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tagListView];
}

-(void)updateHeaderView
{
    NSMutableArray *tagStrArr = [[NSMutableArray alloc]init];
    for(CommentTagMod *mod in tagDataArr)
    {
        NSString *titleStr =  [NSString stringWithFormat:@"%@（%@）",mod.Title,mod.TagNum];
        [tagStrArr addObject:titleStr];
    }
    [tagListView setTags:tagStrArr];
    tagListView.width = [tagListView fittedSize].width;
    tagListView.height = [tagListView fittedSize].height;
    commentListTab.frame = mRect(0,tagListView.bottom+5,kkDeviceWidth,kkDeviceHeight-64-tagListView.height);
}
/*按钮动作*/
-(void)chooseTagWithIndex:(NSInteger)index
{
    CommentTagMod *mod = tagDataArr[index];
    _selectIndex = mod.TagID.integerValue;
    page = 1;
    [self requestTableDataWithTag:_selectIndex];
    
    
}

#pragma mark -- 创建表
- (void)createTableView
{
    
    commentListTab = [[UITableView alloc]initWithFrame:mRect(0,tagListView.bottom, kkDeviceWidth, kkDeviceHeight-64-tagListView.height) style:UITableViewStyleGrouped];
    commentListTab.showsVerticalScrollIndicator = NO;
    commentListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentListTab.delegate = self;
    commentListTab.dataSource = self;
    commentListTab.backgroundColor = [UIColor clearColor];
    
    [commentListTab addHeaderWithTarget:self action:@selector(refreshData)];
    [commentListTab addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.view addSubview:commentListTab];
    
    comTabBg = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, commentListTab.width, commentListTab.height)];
    comTabBg.tipsString=@"哦噢,还没有任何评价哦~";
    [commentListTab addSubview:comTabBg];
   
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*每一个cell就是一段*/
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type==0){
        AllSampleCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllSampleCommentCell"];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"AllSampleCommentCell" owner:self options:nil]firstObject];
        }
        if(dataArr.count!=0){
            CommentListMod *model=dataArr[indexPath.row];
            cell.delegate=self;
            [cell reloadCellWithModel:model];
        }
        return cell;
    }
    else{
    
        CommetListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseName] ;
        if(cell == nil)
        {
            cell = [[CommetListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseName];
        }
        if(dataArr.count>0)
        {
            /*填充数据*/
            CommentListMod *mod = dataArr[indexPath.row];
            [cell initUIWithSampleCommentListMod:mod];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type==0){
        CommentListMod *model;
        if(dataArr.count!=0){
            model=dataArr[indexPath.row];
        }
        return [AllSampleCommentCell getHeightWithModel:model];
    }else
    {
        CommentListMod *model;
        if(dataArr.count!=0){
            model=dataArr[indexPath.row];
        }
        return [CommetListCell getCellHeightWithModel:model];
    
    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView ;
    return headerView;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView;
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -- 更新UI
- (void)updateUI
{
 

}

@end
