//
//  MoveJJViewController.m
//  MopinProject
//
//  Created by happyzt on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "MoveJJViewController.h"
#import "UIRadioControl.h"
#import "TongYongJuanCell.h"
#import "MyCouponModel.h"
#import "CommonEmptyTableBgView.h"

#define LocStr(key) NSLocalizedString(key,@"")

static NSString * identifyName = @"TongYongJuanCell";

@interface MoveJJViewController ()<UIScrollViewDelegate>
{
    
    UIRadioControl *radio;
    UIImageView *_radioBottomImageView;//滑动条
    UIScrollView *_horizontalScrollView;// 水平滑动的ScrollView
    
    UIView *bgView;
    NSInteger _page_num;      //页数
    NSUInteger _page_size;    //每一页显示的数量
    NSUInteger _total_num;   //总记录数
    NSUInteger _total_page;   //总页数
    PersonalInfoSingleModel *_personalModel;
    float itemWidth;
    UIView *topView;
    
    
    UIView *bottomView;
    UILabel  *selectmoPinLab; //以选中墨品劵
    CGFloat selectMPPrice;  //墨品劵价格
    UILabel  *selectshuJiaLab; //已选中书家劵
    CGFloat selectSJPrice;  //书家劵价格
    UILabel  *totalLabel; //合计
    CGFloat totalPrice; //总价格
    
    UITableView *_MpJuanTab;  //表
    NSMutableArray *_MpDataArr; //墨品劵数据源
    
    UITableView *_SjJuanTab;  //表
    NSMutableArray *_SjDataArr; //书家劵数据源
    
    //要传回去的值
    NSString *MpAmountString;  //墨品价格
    NSString *SjAmountString;  //书家劵总额
    NSMutableArray *MpjIdArr;  //墨品劵Id
    NSMutableArray *SjjIdArr;  //书家劵Id
    
    CommonEmptyTableBgView *emptyBgView_1;//空载页一
    CommonEmptyTableBgView *emptyBgView_2;//空载页二
}



@end

@implementation MoveJJViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title=@"动用墨基金";
        [self setNavBackBtnWithType:1];
        
        _page_size=20;
        _page_num = 1;
        _total_num=0;
        
        _MpDataArr = [[NSMutableArray alloc]init];
        _SjDataArr = [[NSMutableArray alloc]init];
        MpjIdArr = [[NSMutableArray alloc]init];
        SjjIdArr = [[NSMutableArray alloc]init];
        
        /*初始化选中的劵*/
        selectMPPrice = 0.0f;
        selectSJPrice = 0.0f;
        totalPrice = 0.0f;
        
    }
    return self;
}

/*TODO:返回上一个界面*/
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认返回后即将清空所有选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
     */
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
 */
#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTopView];

    [self _initContentView];
    
    [self createBottomView];
    
    /*初始化选中的价格*/
    selectMPPrice = _selectMoPinJuanPrice.floatValue;
    selectSJPrice = _selectShuJiaJuanPrice.floatValue;
    
    /*初始化的时候加载数据,默认加载书家劵*/
    [self requestDataWithType:2];
    
}

#pragma mark -- 顶部视图
- (void)createTopView
{
    //创建View
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:topView];
    
    //可用墨品劵
    UILabel  *moPinLab = [XHDHelper createLabelWithFrame:mRect(25, 10,mScreenWidth-50, 30) andText:[NSString stringWithFormat:@"可用墨品劵￥%@, 可用书家劵￥%@",_moPinText.length?_moPinText:@"0.00",_shuJiaText.length?_shuJiaText:@"0.00"] andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    moPinLab.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:moPinLab];
    
}

#pragma mark -- 创建2个tableView
-(void)_initContentView
{
    NSArray *items = [NSArray arrayWithObjects:LocStr(@"书家劵"),LocStr(@"墨品劵"), nil];
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,topView.bottom, kkDeviceWidth,35.5) items:items];
    [radio setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [radio setTitleColor:MainFontColor forState:UIControlStateNormal];
    radio.selectedIndex = 0;
    radio.Font=UIFONT(14);
    radio.enableSwipe  = YES;
    [radio addTarget:self action:@selector(radioValueChanged:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radio];
  
    
    /*tabview背景*/
    _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, radio.bottom, mScreenWidth, mScreenHeight-64-radio.height-125-topView.height)];
    _horizontalScrollView.contentSize = CGSizeMake(_horizontalScrollView.width*items.count, _horizontalScrollView.height);
    _horizontalScrollView.delegate = self;
    _horizontalScrollView.pagingEnabled = YES;
    _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_horizontalScrollView];
    
    //TODO:书家表
    _SjJuanTab = [self createTableExampleWithFrame:mRect(0, 0, kkDeviceWidth, _horizontalScrollView.height)];
    _SjJuanTab.tag = 1110;
    /*空载页*/
    emptyBgView_1 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,iPhone4?40:20,_SjJuanTab.width, _SjJuanTab.height)];
    emptyBgView_1.tipsString=@"哦噢,没有任何可用的书家劵哦~";
    emptyBgView_1.hidden = YES;
    [_SjJuanTab addSubview:emptyBgView_1];
    
    [_horizontalScrollView addSubview:_SjJuanTab];
    
    //TODO:墨品表
    _MpJuanTab = [self createTableExampleWithFrame:mRect(kkDeviceWidth, 0, kkDeviceWidth,_horizontalScrollView.height)];
    _MpJuanTab.tag = 1111;
    /*空载页*/
    emptyBgView_2 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,iPhone4?40:20,_MpJuanTab.width, _MpJuanTab.height)];
    emptyBgView_2.tipsString=@"哦噢,没有任何可用的墨品劵哦~";
    emptyBgView_2.hidden = YES;
    [_MpJuanTab addSubview:emptyBgView_2];
    
    [_horizontalScrollView addSubview:_MpJuanTab];
    
}

/*createTable*/
- (UITableView*)createTableExampleWithFrame:(CGRect)frame
{
    UITableView *  tableView = [[UITableView alloc] initWithFrame:frame];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView setBackgroundView:nil];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    tableView.allowsMultipleSelection=YES;
   
    [tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    return tableView;
}
/*radio 改变的动作*/
- (void)radioValueChanged:(UIRadioControl*)sender
{
    if(sender.selectedIndex==0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _horizontalScrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    else if(sender.selectedIndex == 1)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            _horizontalScrollView.contentOffset = CGPointMake(kkDeviceWidth, 0);
        }];
        if(_SjDataArr.count==0)
        {
           [self requestDataWithType:1];
        }
        
    }
}
#pragma mark -- 底部视图
- (void)createBottomView
{
    //创建View
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom-125-64, mScreenWidth, 125)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    

    //代入的时候还要显示
    /*书家劵*/
    NSString *selectString_1 = [NSString stringWithFormat:@"已选书家劵 ￥%@",self.selectShuJiaJuanPrice.length?_selectShuJiaJuanPrice:@"0.00"];
    selectshuJiaLab = [XHDHelper createLabelWithFrame:mRect(25, 5, (mScreenWidth-50)/2, 30) andText:selectString_1 andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    selectshuJiaLab.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:selectshuJiaLab];

    /*墨品劵*/
     NSString *selectString_2 = [NSString stringWithFormat:@"已选墨品劵 ￥%@",self.selectMoPinJuanPrice.length?_selectMoPinJuanPrice:@"0.00"];
    selectmoPinLab = [XHDHelper createLabelWithFrame:mRect((mScreenWidth-50)/2, 5, (mScreenWidth-50)/2, 30) andText:selectString_2 andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    selectmoPinLab.textAlignment = NSTextAlignmentRight;
    selectmoPinLab.right = bottomView.width-25;
    [bottomView addSubview:selectmoPinLab];
    
    
    [XHDHelper addDivLineWithFrame:CGRectMake(selectshuJiaLab.left, selectmoPinLab.bottom+3, bottomView.width-40, 0.5) SuperView:bottomView];
    
    /*总共*/
    totalLabel = [XHDHelper createLabelWithFrame:mRect(selectshuJiaLab.left, selectshuJiaLab.bottom+10, (mScreenWidth-40)/2, 30) andText:[NSString stringWithFormat:@"合计：%@",@"0.00"] andFont:[UIFont systemFontOfSize:16] AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    /*有带入初始化显示的设置*/
    CGFloat totalPri = _selectMoPinJuanPrice.floatValue+_selectShuJiaJuanPrice.floatValue;
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"合计:￥%.2f",totalPri]];
    [totalStr addAttributes:@{NSFontAttributeName:totalLabel.font} range:NSMakeRange(0, 3)];
    [totalStr addAttributes:@{NSForegroundColorAttributeName:MainFontColor} range:NSMakeRange(0, 3)];
    [totalStr addAttributes:@{NSFontAttributeName:UIFONT_bold(13)} range:NSMakeRange(4, 1)];
    [totalStr addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(4, 1)];
    
    [totalStr addAttributes:@{NSFontAttributeName:UIFONT_bold(18)} range:NSMakeRange(4, totalStr.length-4)];
    [totalStr addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(4, totalStr.length-4)];
    totalLabel.attributedText = totalStr;
    totalLabel.right  = bottomView.width-25;
    totalLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:totalLabel];
    
    
    //使用按钮
    UIButton *useButton = [XHDHelper getRedGeneralButtonWithFrame:CGRectMake(0, totalLabel.bottom+5, mScreenWidth, kkSureButtonH) AndTitleString:@"使用"];
    [useButton addTarget:self action:@selector(useAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:useButton];
    
}

#pragma mark ---- 使用劵的动作  ------- ok
- (void)useAction:(UIButton *)button
{
    /*遍历数组，获取ID*/
    for(MyCouponModel *mod in _MpDataArr)
    {
        if(mod.isChoose==YES)
        {
            [MpjIdArr addObject:mod.CouponID];
        }
    }
    for(MyCouponModel *mod in _SjDataArr)
    {
        if(mod.isChoose==YES)
        {
            [SjjIdArr addObject:mod.CouponID];
        }
    }
    
    if(MpjIdArr.count==0&&SjjIdArr.count==0)
    {
        [SVProgressHUD showErrorWithStatus:@"您还未选择任何可用劵~"];
        _selectMoPinJuanIDString = @"";
        _selectShuJiaJuanIDString = @"";
        if(_emptyChoosedId)
        {
            _emptyChoosedId();
        }
        return;
    }
    MpAmountString = [NSString stringWithFormat:@"%.f",selectMPPrice>0.0f?selectMPPrice:0.0f];
    SjAmountString = [NSString stringWithFormat:@"%.f",selectSJPrice>0.0f?selectSJPrice:0.0f];
    /*传使用了都少的墨品卷，多少书家劵，以及书家劵和墨品劵的id数组*/
    if(_finishChooseJuan)
    {
        _finishChooseJuan(MpAmountString,
                          SjAmountString,
                          MpjIdArr,
                          SjjIdArr);
        [self.navigationController popViewControllerAnimated:YES];
    }

}

//TODO:UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1111)
    {
        return _MpDataArr.count;
    }
    else {
        
        return _SjDataArr.count;
    }
}

//TODO:cell的显示设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TongYongJuanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyName];
    if(cell==nil)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:identifyName owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*填充数据*/
    if(tableView.tag == 1111)
    {
        if(_MpDataArr.count>0)
        {
            MyCouponModel *mod = _MpDataArr[indexPath.row];
            cell.mod = mod;
            if(mod.isChoose == YES)
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            
        }
    }
    else
    {
        if(_SjDataArr.count>0)
        {
            MyCouponModel *mod = _SjDataArr[indexPath.row];
            cell.mod = mod;
            if(mod.isChoose == YES)
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    
    return cell;
    
}

/*cell的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag == 1111)
    {
        MyCouponModel *mod = _MpDataArr[indexPath.row];
        mod.isChoose = !mod.isChoose;
        [_MpDataArr replaceObjectAtIndex:indexPath.row withObject:mod];
        
        /*加上这个价格，传给显示的界面*/
        CGFloat MPJG = mod.Amount.floatValue;
        [self upBottomViewWithMPPrice:MPJG SJPrice:0.0f];
    }
    else
    {
        MyCouponModel *mod = _SjDataArr[indexPath.row];
        mod.isChoose = !mod.isChoose;
        [_SjDataArr replaceObjectAtIndex:indexPath.row withObject:mod];
        CGFloat SJJG = mod.Amount.floatValue;
        [self upBottomViewWithMPPrice:0.0f SJPrice:SJJG];
        
    }
   
}
//TODO:取消选择
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if(tableView.tag == 1111)
    {
        MyCouponModel *mod = _MpDataArr[indexPath.row];
        mod.isChoose = !mod.isChoose;
        [_MpDataArr replaceObjectAtIndex:indexPath.row withObject:mod];
        /*减去这个价格，传给显示的界面，将ID从数组中删除*/
        CGFloat MPJG = mod.Amount.floatValue;
        [self upBottomViewWithMPPrice:-MPJG SJPrice:0.0f];
    }
    else 
    {
        MyCouponModel *mod = _SjDataArr[indexPath.row];
        mod.isChoose = !mod.isChoose;
        [_SjDataArr replaceObjectAtIndex:indexPath.row withObject:mod];
        CGFloat SJJG = mod.Amount.floatValue;
        [self upBottomViewWithMPPrice:0.0f SJPrice:-SJJG];
    }
}



- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


#pragma mark -- ScrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _horizontalScrollView)
    {
        int x = _horizontalScrollView.contentOffset.x;
        
        if(x<_horizontalScrollView.width)
        {
            radio.selectedIndex = 0;
        }
        else if(x<_horizontalScrollView.width*2)
        {
           radio.selectedIndex = 1;
        }
    }

}

#pragma mark -- 网络请求相关
//TODO:下拉刷新
- (void)refreshData
{
    _page_num = 1;
    [self requestDataWithType:radio.selectedIndex+1];
}
//TODO:加载更多
- (void)loadMoreData
{
    _page_num ++;
    [self requestDataWithType:radio.selectedIndex+1];
}

#pragma mark -- 获取劵的列表
- (void)requestDataWithType:(NSInteger)type
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MyCoupon" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
     [parameterDic setValue:_PMIDofArt forKey:@"PMID"];
     [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
     [parameterDic setValue:[NSString stringWithFormat:@"%ld",type] forKey:@"Type"];
     [parameterDic setValue:[NSString stringWithFormat:@"%ld",_page_num] forKey:@"PageIndex"];
    [parameterDic setValue:[NSString stringWithFormat:@"%ld",_page_size] forKey:@"PageSize"];
    
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
                //填充数据
                MyCouponModel *mod = [[MyCouponModel alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                //根据类型来
                if(type == 1)
                {
                  [_MpDataArr addObject:mod];
                }
                else if(type==2)
                {
                  [_SjDataArr addObject:mod];
                }
            }

        }
        
#if 0// 测试数据
        /*墨品
        if(_MpDataArr.count == 0)
        {
            for(NSInteger i=0;i<10;i++)
            {
                MyCouponModel *mod = [[MyCouponModel alloc]init];
                mod.Type = @"1";//[NSString stringWithFormat:@"%ld",radio.selectedIndex+1];
                mod.EndTime = @"2015-12-25";
                mod.CouponID = [NSString stringWithFormat:@"%ld",100+i];
                mod.Amount = @"500";
                mod.Source = @"1";
                mod.isChoose = NO;
                [_MpDataArr addObject:mod];
            }
        }
        //书家
        if(_SjDataArr.count == 0)
        {
            for(NSInteger i=0;i<10;i++)
            {
                MyCouponModel *mod = [[MyCouponModel alloc]init];
                mod.Type = @"2";//[NSString stringWithFormat:@"%ld",radio.selectedIndex+1];
                mod.EndTime = @"2015-12-25";
                mod.CouponID =  [NSString stringWithFormat:@"%ld",200+i];
                mod.Amount = @"500";
                mod.Source = @"2";
                mod.isChoose = NO;
                [_SjDataArr addObject:mod];
            }
        }
        */

#endif
        [SVProgressHUD dismiss];
        [_MpJuanTab footerEndRefreshing];
        [_SjJuanTab footerEndRefreshing];
        [_MpJuanTab reloadData];
        [_SjJuanTab reloadData];
        emptyBgView_1.hidden = _SjDataArr.count==0?NO:YES;
        emptyBgView_2.hidden = _MpDataArr.count==0?NO:YES;
        
        [self setDefaultJuan];
        
    } failure:^(NSError *error){
        
        [_MpJuanTab footerEndRefreshing];
        [_SjJuanTab footerEndRefreshing];
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}
#pragma mark -- 更新价格Label
- (void)upBottomViewWithMPPrice:(CGFloat)mpJage
                        SJPrice:(CGFloat)sjJage
{
    selectMPPrice += mpJage;
    selectSJPrice += sjJage;
    totalPrice = selectMPPrice + selectSJPrice;
    
    selectmoPinLab.text = [NSString stringWithFormat:@"已选墨品劵￥%.2f",selectMPPrice>0.0f?selectMPPrice:0.0f];
    
    selectshuJiaLab.text = [NSString stringWithFormat:@"已选书家劵￥%.2f",selectSJPrice>0.0f?selectSJPrice:0.0f];
    
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"合计:￥%.2f",totalPrice]];
    [totalStr addAttributes:@{NSFontAttributeName:totalLabel.font} range:NSMakeRange(0, 3)];
    [totalStr addAttributes:@{NSForegroundColorAttributeName:MainFontColor} range:NSMakeRange(0, 3)];
    [totalStr addAttributes:@{NSFontAttributeName:UIFONT_bold(13)} range:NSMakeRange(4, 1)];
    [totalStr addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(4, 1)];
    
    [totalStr addAttributes:@{NSFontAttributeName:UIFONT_bold(18)} range:NSMakeRange(4, totalStr.length-4)];
    [totalStr addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(4, totalStr.length-4)];
    
    totalLabel.attributedText =totalStr;
}

#pragma mark -- 代入劵的处理
- (void)setDefaultJuan
{
   /*根据传过来的劵的ID，分别遍历两个数组，将对应的Mod里面的值设置未YES。重新刷新表*/
    if(_selectMoPinJuanIDString.length>0)
    {
        NSArray *MpIDArr = [_selectMoPinJuanIDString componentsSeparatedByString:@","];
        if(MpIDArr.count>0)
        {
            for(NSInteger i=0;i<MpIDArr.count;i++)
            {
                NSString *idMark = MpIDArr[i];
                for(NSInteger j=0;j<_MpDataArr.count;j++)
                {
                    MyCouponModel *mod = _MpDataArr[j];
                    if([mod.CouponID isEqualToString:idMark])
                    {
                        mod.isChoose  = YES;
                        [self upBottomViewWithMPPrice:mod.Amount.floatValue SJPrice:0.0f];
                    }
                
                }
            
            }
        }
       [_MpJuanTab reloadData];
    }
    
    if(_selectShuJiaJuanIDString.length>0)
    {
        NSArray *SjIDArr = [_selectShuJiaJuanIDString componentsSeparatedByString:@","];
        if(SjIDArr.count>0)
        {
            for(NSInteger i=0;i<SjIDArr.count;i++)
            {
                NSString *idMark = SjIDArr[i];
                for(NSInteger j=0;j<_SjDataArr.count;j++)
                {
                    MyCouponModel *mod = _SjDataArr[j];
                    if([mod.CouponID isEqualToString:idMark])
                    {
                        mod.isChoose  = YES;
                         [self upBottomViewWithMPPrice:0.0f SJPrice:mod.Amount.floatValue];
                    }
                    
                }
                
            }
        }
        [_SjJuanTab reloadData];
    }

}

@end
