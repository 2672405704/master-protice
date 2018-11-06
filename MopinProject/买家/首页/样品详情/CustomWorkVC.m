//
//  CustomWorkVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/15.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CustomWorkVC.h"
#import "XHDHelper.h"
#import "UIRadioControl.h"
#import "KuangBiaoChooseView.h"
#import "BATableView.h"
#import "ChineseString.h"
#import "CommonEmptyTableBgView.h"

#pragma mark -- 选中的Cell
@interface ChooseCell : UITableViewCell


@property (nonatomic,strong)UIImageView *chooseIcon;  //选中图标
@property (nonatomic,strong)NSString*content;
@property(nonatomic,strong)UILabel *contentLab;   //标题
@property(nonatomic,assign)BOOL isChoose; //是否选中

@end

@implementation ChooseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        [self initUI];
    
    }
    return self;
}
#pragma mark -- 画分割线
-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.5f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
}
    
-(void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    _contentLab = [XHDHelper createLabelWithFrame:mRect(25, 0, kkDeviceWidth-80, 40) andText:_content andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    _contentLab.numberOfLines = 0;
    [self addSubview:_contentLab];
    
    _chooseIcon = [[UIImageView alloc]initWithFrame:mRect(0, 0, 15, 15)];
    _chooseIcon.image = mImageByName(@"gou_red_sample");
    _chooseIcon.right = kkDeviceWidth-35;
    _chooseIcon.top = self.height/2.0-7.5;
    _chooseIcon.hidden = YES;
    [self addSubview:_chooseIcon];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    /*计算高度*/
    CGFloat height = [XHDHelper heightOfString:_content.length?_content:@"1234" font:_contentLab.font maxSize:CGSizeMake(kkDeviceWidth-85, 1000)].height;
    _contentLab.height = height>40?height:40;
    _contentLab.text = _content;
    _chooseIcon.right = kkDeviceWidth-30;
    _chooseIcon.top = self.height/2.0-7.5;
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        _chooseIcon.hidden = NO;
        _contentLab.textColor = THEMECOLOR_1;
    
    }
    else
    {
        _chooseIcon.hidden = YES;
        _contentLab.textColor = MainFontColor;
    }
    
}

@end


#pragma mark -- 控制器
static NSString *cellName_1 = @"cellName_1";
static NSString *cellName_2 = @"cellName_2";
@interface CustomWorkVC ()<UIScrollViewDelegate,UITextViewDelegate,BATableViewDelegate>
{
    UIScrollView *_baseScollerView; //基础滚动视图
    UIRadioControl* mainRadio;  //基础顶部视图
    UITableView *FirstView;  //第一个视图
    UIView *chooseButtonBg;
    
    BATableView *secondTabView; //第二个表的内容
   
    UIView *thirdView;  //第三个视图
    UITextView *_customFillTextView;//自选输入框
    
    UIButton *commitBnt_1;
     UIButton* commitBnt_0; //书家推荐确认按钮
    
    NSMutableArray *recommandDataArr;  //推荐内容数组
    NSString *chooseRecommandContent; //选中的推荐内容
    
    NSMutableArray *selfChooseDataArr; //筛选列表的数据源
    NSMutableArray *indexArr; // 索引数组
    NSMutableArray *contentArr;// 内容数组
    NSIndexPath *myIndexPath;
    
    CommonEmptyTableBgView *emptyBgView_1; //空载页_1
    CommonEmptyTableBgView *emptyBgView_2; //空载页_2
    
}


@end

@implementation CustomWorkVC

-(void)setMinNum:(NSInteger)minNum
{
   if(_minNum!=minNum)
   {
       _minNum  = minNum;
   }
}
-(void)setMaxNum:(NSInteger)maxNum
{
    if(_maxNum!=maxNum)
    {
        _maxNum = maxNum;
    }
}


- (instancetype)initWithArtID:(NSString*)artID
             AndChooseContent:(NSString *)chooseContent
{
    self = [super init];
    
    if (self) {
        
        _ArtID = artID;
        _chooseContent = chooseContent;
        [mNotificationCenter addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil]; //(即将显示)
        [mNotificationCenter addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil]; //(即将隐藏)
        
        //请求数据
        recommandDataArr = [[NSMutableArray alloc]init];
        selfChooseDataArr = [[NSMutableArray alloc]init];
        
        [self requestDataRecommandContent];
        [self requestDateOfSelfChooseContent];
        
    }
    return self;
}

#pragma mark -- 返回
- (void)backBtnClick
{
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确定放弃编辑吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        
    });
    
}
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


#pragma mark -- 创建滚动视图
- (void)createBaseScrollerView
{
    _baseScollerView = [[UIScrollView alloc]initWithFrame:mRect(0, 35, kkDeviceWidth, kkDeviceHeight-99)];
    _baseScollerView.showsHorizontalScrollIndicator = NO;
    _baseScollerView.showsVerticalScrollIndicator = NO;
    _baseScollerView.contentSize = CGSizeMake(kkDeviceWidth*3, 0);
    _baseScollerView.tag= 3333;
    _baseScollerView.delegate = self;
    _baseScollerView.pagingEnabled = YES;
    [self.view addSubview:_baseScollerView];
}

#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"墨品定制";
    [self setNavBackBtnWithTitle:@"取消"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
    [self createBaseScrollerView];
    [self createRecommandContentView];
    [self createSelfChooseContentView];
    [self createSelfFillContentView];

}


#pragma mark -- 段头
- (void)createHeaderView
{
    NSArray *items = @[@"书家推荐",@"自选内容",@"自拟内容"];
    mainRadio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,-0.5, kkDeviceWidth,35.5) items:items];
    [mainRadio setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [mainRadio setTitleColor:MainFontColor forState:UIControlStateNormal];
    mainRadio.selectedIndex = 0;
    mainRadio.Font=UIFONT(14);
    mainRadio.enableSwipe  = YES;
    mainRadio.tag = 750;
    [mainRadio addTarget:self action:@selector(radioValueChanged:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainRadio];
    
}

- (void)radioValueChanged:(UIRadioControl*)radio
{
    [_customFillTextView resignFirstResponder];
    if(radio.tag == 750)
    {
        switch (radio.selectedIndex) {
            case 0:
            {
               [UIView animateWithDuration:0.3 animations:^{
                   _baseScollerView.contentOffset = CGPointMake(0, 0);
               }];
                [FirstView reloadData];
            }
                break;
            case 1:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    _baseScollerView.contentOffset = CGPointMake(kkDeviceWidth, 0);
                }];
                [secondTabView reloadData];
            }
                break;
            case 2:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    _baseScollerView.contentOffset = CGPointMake(kkDeviceWidth*2, 0);
                }];
            }
                break;
                
            default:
                break;
        }

    }
    

}
#pragma mark -- 1-推荐内容------------------第一个推荐内容
- (void)createRecommandContentView
{
    FirstView = [[UITableView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, _baseScollerView.height-45) style:UITableViewStylePlain];
    FirstView.backgroundColor = [UIColor clearColor];
    FirstView.delegate = self;
    FirstView.dataSource = self;
    FirstView.tag = 1070;
    FirstView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去除于的分割线
    [self setExtraCellLineHidden:FirstView];
    FirstView.allowsMultipleSelection = NO;
    [FirstView reloadData];
    
    /*空载页*/
    emptyBgView_1 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, FirstView.width, FirstView.height)];
    emptyBgView_1.tipsString=@"哦噢,还没有任何推荐哦~";
    [FirstView addSubview:emptyBgView_1];
    
    
     [_baseScollerView addSubview:FirstView];
    
    commitBnt_0 = [XHDHelper getRedGeneralButtonWithFrame:mRect(0, _baseScollerView.height-45, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commitBnt_0.titleLabel.font = UIFONT_Tilte(16);
    commitBnt_0.hidden = YES;
    [commitBnt_0 addTarget:self action:@selector(commitRecommentContentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScollerView addSubview:commitBnt_0];
    
}
/*去除多余的分割线*/
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/*推荐内容确认按钮*/
-(void)commitRecommentContentAction:(UIButton*)sender
{
     if(chooseRecommandContent.length==0)
     {
         [SVProgressHUD showErrorWithStatus:@"你还未选中推荐内容~"];
         return;
     }
    [_delegate finishedChooseWorkContent:chooseRecommandContent];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 2-自选内容----------------第二个：自选内容
- (void)createSelfChooseContentView
{
    
    secondTabView = [[BATableView alloc] initWithFrame:mRect(kkDeviceWidth, 0, kkDeviceWidth, _baseScollerView.height)];
    secondTabView.delegate = self;
    /*空载页*/
    emptyBgView_2 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, secondTabView.width, secondTabView.height)];
    emptyBgView_2.tipsString=@"哦噢,还没有任何自选内容哦~";
    [secondTabView addSubview:emptyBgView_2];
    
    secondTabView.tag = 1080;
    [_baseScollerView addSubview:secondTabView];
}

#pragma mark -- UITableViewDataSource
//索引标题
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    NSMutableArray * indexTitles = [NSMutableArray array];
    if(tableView.tag == 1080)
    {
    
        for (NSString* indexStr in indexArr )
        {
            [indexTitles addObject:indexStr];
        }
    }
   return indexTitles;
}

/*段头名字*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1070)
    {
        return @"";
      
    }else
    {
        NSString *titleStr = [NSString stringWithFormat:@"   %@",indexArr[section]];
        return titleStr;
    }
}
/*多少段*/
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 1070)
    {
        return 1;
    
    }else{

        return contentArr.count;
    }
   
}
/*每一段多少行*/
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1070)
    {
       return recommandDataArr.count;
        
    }else
    {
        return [contentArr[section] count];
    }
    
}
/*每一行有多高*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44;
   if(tableView.tag == 1070)
   {
       NSString *contentStr = recommandDataArr[indexPath.row];
       rowHeight = [XHDHelper heightOfString:contentStr font:UIFONT(15) maxSize:CGSizeMake(kkDeviceWidth-80, 1000)].height;
       rowHeight = rowHeight>44?rowHeight:44;
       
   }else
   {
       rowHeight = 44;
   }
    return rowHeight;
}

//TODO:每一行cell怎么显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*推荐内容*/
    if(tableView.tag == 1070)
    {
       ChooseCell * cell_1 = [tableView dequeueReusableCellWithIdentifier:cellName_1];
        if (!cell_1)
        {
            cell_1 = [[ChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName_1];
        }
        cell_1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell_1.selectedBackgroundView = [[UIView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, cell_1.height)];
        cell_1.selectedBackgroundView.backgroundColor = [UIColor redColor];
        /*填充每一行的内容*/
        if(recommandDataArr.count>0)
        {
            cell_1.content = recommandDataArr[indexPath.row];
            
            if([_chooseContent isEqualToString:recommandDataArr[indexPath.row]])
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                myIndexPath = indexPath;
            }
            
        }
        return cell_1;
    }
    /*自选内容*/
    else
    {
        UITableViewCell * cell_2 = [tableView dequeueReusableCellWithIdentifier:cellName_2];
        if (!cell_2)
        {
            cell_2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName_2];
        }
        cell_2.backgroundColor = [UIColor whiteColor];
        cell_2.selectionStyle = UITableViewCellSelectionStyleNone;
        /*加分割线*/
        [XHDHelper addDivLineWithFrame:mRect(25, cell_2.height-0.5, cell_2.width-50, 0.5) SuperView:cell_2];
        if(contentArr.count>0)
        {
            NSString *contentStr = [NSString stringWithFormat:@"   %@",contentArr[indexPath.section][indexPath.row]];
            cell_2.textLabel.text = contentStr;
            cell_2.textLabel.font = UIFONT(15);
            cell_2.textLabel.textColor = MainFontColor;
            
            /*自选内容代入处理*/
            if([_chooseContent isEqualToString:contentArr[indexPath.section][indexPath.row]])
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                cell_2.textLabel.textColor = THEMECOLOR_1;
                myIndexPath = indexPath;
            }
        }
         return cell_2;
    }
}

/*tableView的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag == 1070)
    {
        if(![myIndexPath isEqual:indexPath])
        {
            ChooseCell *cell = [tableView cellForRowAtIndexPath:myIndexPath];
            cell.selected  = NO;
        }
         chooseRecommandContent  = recommandDataArr[indexPath.row];
        /*代理传回选中的值*/
        if([_delegate respondsToSelector:@selector(finishedChooseWorkContent:)])
        {
            
            [_delegate finishedChooseWorkContent:recommandDataArr[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:myIndexPath];
        cell.textLabel.textColor = THEMECOLOR_1;
        /*代理传回选中的值*/
        if([_delegate respondsToSelector:@selector(finishedChooseWorkContent:)])
        {
            
            [_delegate finishedChooseWorkContent:contentArr[indexPath.section][indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1080)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:myIndexPath];
        cell.textLabel.textColor = MainFontColor;
        
    }

}

#pragma mark -- 3-自拟内容 -----------第三个
- (void)createSelfFillContentView
{
    thirdView = [[UIView alloc]initWithFrame:mRect(kkDeviceWidth*2, 0, kkDeviceWidth, _baseScollerView.height)];
    [_baseScollerView addSubview:thirdView];
    
    //内容正文
    CGRect frame = CGRectMake(0, 0, kkDeviceWidth, 110);
    UIView *textViewBg = [[UIView alloc] initWithFrame:frame];
    textViewBg.backgroundColor = [UIColor whiteColor];
    [thirdView addSubview:textViewBg];
    
    _customFillTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-20, frame.size.height-10)];
    _customFillTextView.backgroundColor = [UIColor whiteColor];
    _customFillTextView.delegate = self;
    _customFillTextView.text =_chooseContent.length?_chooseContent:@"请输入内容正文，如：紫气东来";
    _customFillTextView.font = [UIFont systemFontOfSize:12.5];
    _customFillTextView.textColor = [UIColor lightGrayColor];
    [textViewBg addSubview:_customFillTextView];
    
    
     commitBnt_1 = [XHDHelper getRedGeneralButtonWithFrame:mRect(0, thirdView.height-45, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commitBnt_1.titleLabel.font = UIFONT_Tilte(16);
    [commitBnt_1 addTarget:self action:@selector(commitSelfFillContentAction:) forControlEvents:UIControlEventTouchUpInside];
    [thirdView addSubview:commitBnt_1];
    
}

#pragma mark -- 自拟内容确认
- (void)commitSelfFillContentAction:(UIButton*)sender
{
     [_customFillTextView resignFirstResponder];
   if(_customFillTextView.text.length==0||[_customFillTextView.text isEqualToString:@"请输入内容正文，如：紫气东来"])
   {
       [SVProgressHUD showErrorWithStatus:@"请输入您要输入的内容"];
       return;
   }
    
    //内容字数限制提示
    if(_customFillTextView.text.length<_minNum)
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"内容字数%ld-%ld字",_minNum,_maxNum]];
        return;
    }
    if(_customFillTextView.text.length>_maxNum)
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"内容字数%ld-%ld字",_minNum,_maxNum]];
        return;
    }

    //代理传回选中的值
    if([_delegate respondsToSelector:@selector(finishedChooseWorkContent:)])
    {
        [_delegate finishedChooseWorkContent:_customFillTextView.text];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


#pragma mark -- textdelegate
/*如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：*/
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString: @"请输入内容正文，如：紫气东来"])
    {
       textView.text=@"";
    }
    textView.textColor = MainFontColor;
    return YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
   
    _customFillTextView.text = [XHDHelper delSpaceWith:_customFillTextView.text];
    if (_customFillTextView.text.length==0)
    {
        NSString *placeStr;
        placeStr =  @"请输入内容正文，如：紫气东来";
        _customFillTextView.text = placeStr;
        _customFillTextView.textColor = TipsFontColor;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
//     NSString *detailString = [textView.text stringByReplacingCharactersInRange:range withString:text];
// 
//    NSUInteger charLen = [self lenghtWithString:detailString];
//    //该判断用于联想输入
//    if(charLen>_maxNum*2)
//    {
//        textView.text = [textView.text substringToIndex:_maxNum];
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"内容字数%ld-%ld字",_minNum,_maxNum]];
//        return NO;
//    }
//    
    return YES;
}

// 计算转换后字符的个数
- (NSUInteger) lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    //该判断用于联想输入
//    if(textView.text.length>_maxNum)
//    {
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"内容字数%ld-%ld字",_minNum,_maxNum]];
//        textView.text = [textView.text substringToIndex:_maxNum];
//
//    }
//}
/*文字输入框*/
#pragma mark -- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if(scrollView.tag == 3333)
  {
    CGFloat x = scrollView.contentOffset.x;
    if(x<kkDeviceWidth)
    {
        mainRadio.selectedIndex = 0;
    }
    else if(x<kkDeviceWidth*2)
    {
        mainRadio.selectedIndex = 1;
    }
    else if(x<kkDeviceWidth*3)
    {
        mainRadio.selectedIndex = 2;
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- 网络请求(请求推荐内容和自选内容)
/*推荐内容*/
/*
"data": [
{
    "ID": "2",
    "RCContent": "大爱无疆"
},
{
    "ID": "3",
    "RCContent": "爱的代价"
}
         ],
*/
- (void)requestDataRecommandContent
{
    [FirstView reloadData];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetRecommendList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_ArtID.length?_ArtID:@"1" forKey:@"ArtID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                //填充数据
                NSString *RCContent = dic[@"RCContent"];
                [recommandDataArr addObject:RCContent];
            }
        }
        [FirstView reloadData];
        if(recommandDataArr.count==0)
        {
            emptyBgView_1.hidden = NO;
            commitBnt_0.hidden = YES;
            
        }else
        {
           emptyBgView_1.hidden = YES;
            commitBnt_0.hidden = NO;
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}
/*自选内容*/
/*
 "data": [
 {
 "ID": "2",
 "Content": "大爱无疆"
 },
 {
 "ID": "3",
 "Content": "爱的代价"
 }
 ],
 */
- (void)requestDateOfSelfChooseContent
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetOptionalList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_ArtID forKey:@"ArtID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                NSString *str = dic[@"Content"];
                [selfChooseDataArr addObject:str];
            }
             [self selfChooseTableReload];
            
            if(selfChooseDataArr.count==0)
            {
                emptyBgView_2.hidden = NO;
            }else
            {
                emptyBgView_2.hidden = YES;
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}
/*跟新表的一个方法*/
- (void)selfChooseTableReload
{
    indexArr = [ChineseString IndexArray:selfChooseDataArr];
    contentArr = [ChineseString LetterSortArray:selfChooseDataArr];
    
    [secondTabView reloadData];
    
}

#pragma mark --- 键盘遮挡效果 --------------
- (void)keyBoardWillHide:(NSNotification *)info//(即将隐藏)
{
    [UIView animateWithDuration:0.25 animations:^{
        commitBnt_1.bottom = _baseScollerView.height;
    }];
}
//(即将显示)
- (void)keyBoardWillShow:(NSNotification *)info{
    //获取键盘信息
    NSDictionary *keyBoardInfo = info.userInfo;
    
    //获取
    NSValue *rectValue = keyBoardInfo[UIKeyboardFrameEndUserInfoKey];
    //将NSValue --> CGRect
    //1.准备一个空的CGRect变量
    CGRect keyBoardFrame;
    
    //2.将该变量交给NSValue对象
    [rectValue getValue:&keyBoardFrame];
    
    //修改当前view的y坐标
    NSInteger offset = keyBoardFrame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        commitBnt_1.bottom =  _baseScollerView.height-offset;
    }];
}


@end
