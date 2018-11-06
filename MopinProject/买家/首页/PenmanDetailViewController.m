//
//  PenmanDetailViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PenmanDetailViewController.h"
#import "PenmanDetailModel.h"
#import "UIImageView+WebCache.h"
#import "FundCell.h"
#import "CouponMainModel.h"
#import "EvaluteSampleCell.h"
#import "PenmanDetailSampleCell.h"
#import "PenmanDetailSampleModel.h"
#import "PenmanDetailCommentModel.h"
#import "CouponMopinModel.h"
#import "ExmapleWorkDetailVC.h"
#import "ShareTools.h"
#import "LoginViewController.h"
#import "AllSampleViewController.h"
#import "CustomCommentVC.h"
#import "PublicWelfareManager.h"

@interface PenmanDetailViewController ()<UITableViewDataSource,UITableViewDelegate,FundCellDelegate,EvaluteSampleCellDelegate>
{
    PersonalInfoSingleModel *_personalModel;
    PenmanDetailModel *_detailModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;  //书家图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage1; //显示书家级别
@property (weak, nonatomic) IBOutlet UIImageView *iconImage2; //显示是否签约
@property (weak, nonatomic) IBOutlet UIImageView *iconImage3; //显示排名上升
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;      //显示名字
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;  //显示关注
@property (weak, nonatomic) IBOutlet UIView *infoBgView;      //简介背景
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;      //简介
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;     //润格价钱和均价
@property (weak, nonatomic) IBOutlet UIView *commentBgView;   //评论背景
@property (weak, nonatomic) IBOutlet UIButton *commentCountBtn; //评论个数
@property (weak, nonatomic) IBOutlet UILabel *commentTipLabel;  //评论提示没有评价
@property (weak, nonatomic) IBOutlet UIView *sampleBgView;      //样品背景
@property (weak, nonatomic) IBOutlet UIButton *sampleCountBtn;  //样品个数
@property (weak, nonatomic) IBOutlet UILabel *sampleTipLabel;   //样品提示没有样品
@property (weak, nonatomic) IBOutlet UIView *couponBgView;      //书家券背景
@property (weak, nonatomic) IBOutlet UILabel *couponTipLabel;   //书家券提示没有书家券
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UITableView *sampleTableView;
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;

@property (weak, nonatomic) IBOutlet UIImageView *publicFreeIcon; //公益
@property (weak, nonatomic) IBOutlet UILabel *stackNumTipLabel;//定制数量为0 提示
@property (weak, nonatomic) IBOutlet UILabel *penmanLabel;



@end

@implementation PenmanDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*添加点赞，收藏后的通知*/
    [mNotificationCenter addObserver:self selector:@selector(downloadPenmanInfo) name:RefreshPenmanDetail object:nil];
    
    self.navigationItem.title=@"书家主页";
    [self setNavBackBtnWithType:1];
    [self setRightNavImageIconWithFrame:CGSizeMake(20, 21) andImageStr:@"share_penman.png"];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    _bgScrollView.hidden=YES;
    [_priceLabel adjustsFontSizeToFitWidth];
    [self createTableView];
    
    [self downloadPenmanInfo];
    
}
//TODO:分享
- (void)rightNavBtnClick
{
    if(!_personalModel.isLogin){
        [self login];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"http://%@/moping-h5/page/penmaninfo?id=%@",SHARE_URL,_penmanID];
//    [ShareTools shareAllButtonClickHandler:[NSString stringWithFormat:@"直接向著名书法家%@定制你喜欢的书法作品。",_detailModel.TrueName] andUser:nil andUrl:url andDes:nil andTitle:[NSString stringWithFormat:@"著名书法家%@的个人主页",_detailModel.TrueName]];
    CouponMopinModel *couponModel;
    for(CouponMopinModel *model in _detailModel.CouponArr){
        if(model.Type.intValue==2){
            couponModel=model;
            break;
        }else{
            couponModel=[[CouponMopinModel alloc]init];
            couponModel.BatchID=@"0";
        }
    }
//    [ShareTools shareAllButtonClickHandler:[NSString stringWithFormat:@"直接向著名书法家%@定制你喜欢的书法作品。",_detailModel.TrueName] andType:ShareMoPinPenmanType andUrl:url andDes:nil andTitle:[NSString stringWithFormat:@"著名书法家%@的个人主页",_detailModel.TrueName]];
    
    ShareMopinModel *shareModel=[[ShareMopinModel alloc]init];
    shareModel.desc=[NSString stringWithFormat:@"直接向著名书法家%@定制你喜欢的书法作品。",_detailModel.TrueName];
    shareModel.type=ShareMoPinPenmanType;
    shareModel.title=[NSString stringWithFormat:@"著名书法家%@的个人主页",_detailModel.TrueName];
    shareModel.shareUrl=url;
    shareModel.sharedId=couponModel.BatchID;
    [ShareTools shareAllButtonClickHandler:shareModel andSucess:^{
        [self reloadCouponWithType:2 andDeleteModel:couponModel];
    }];
}
//TODO:刷新书家券
- (void)reloadCouponWithType:(NSInteger)type andDeleteModel:(CouponMopinModel *)model
{
    NSMutableArray *tempArr=[_detailModel.CouponArr mutableCopy];
    [tempArr removeObject:model];
    
    _detailModel.CouponArr=[tempArr copy];
    [_couponTableView reloadData];
    
    //刷新视图
    if(_detailModel.CouponArr.count==0){
        _couponTipLabel.hidden=NO;
    }
    CGRect frame=_couponTableView.frame;
    frame.size.height=_couponTableView.contentSize.height;
    _couponTableView.frame=frame;
    
    frame=_couponBgView.frame;
    frame.size.height=CGRectGetMaxY(_couponTableView.frame)+40;
    frame.origin.y=CGRectGetMaxY(_sampleBgView.frame);
    _couponBgView.frame=frame;
    
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_couponBgView.frame));
}
//TODO:关注
- (IBAction)attentionBtnClick:(id)sender {
    if(!_personalModel.isLogin){
        [self login];
        return;
    }
    _attentionBtn.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"AttendPenmanDeal" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_penmanID forKey:@"PenmanID"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:_detailModel.IsAttend forKey:@"State"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _attentionBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {

            _detailModel.IsAttend=_detailModel.IsAttend.intValue==1?@"2":@"1";
            if(_detailModel.IsAttend.intValue==1){
                            [SVProgressHUD showSuccessWithStatus:@"关注已取消"];
                _detailModel.AttendNum=[NSString stringWithFormat:@"%@",@(_detailModel.AttendNum.integerValue-1)];
                [_attentionBtn setTitle:[NSString stringWithFormat:@"关注 %@",_detailModel.AttendNum] forState:UIControlStateNormal];
            }else{
                 [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                _detailModel.AttendNum=[NSString stringWithFormat:@"%@",@(_detailModel.AttendNum.integerValue+1)];
                [_attentionBtn setTitle:[NSString stringWithFormat:@"已关注 %@",_detailModel.AttendNum] forState:UIControlStateNormal];
                
                for(CouponMopinModel *model in _detailModel.CouponArr){
                    if(model.Type.intValue==1){
                        [self reloadCouponWithType:1 andDeleteModel:model];
                        break;
                    }
                }
            }
        }
    } failure:^(NSError *error){
        _attentionBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
- (void)createTableView
{
    for(int i=0;i<2;i++){
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,kkDeviceWidth-60, 100)];
        footerView.backgroundColor=self.view.backgroundColor;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看所有评价" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitleColor:toPCcolor(@"ca3b2b") forState:UIControlStateNormal];
        button.frame=CGRectMake((kkDeviceWidth-125-60)/2, 20, 125, 40);
        [footerView addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:@"red_button_penman.png"] forState:UIControlStateNormal];
        if(i==0){
            [button addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
             _commentTableView.tableFooterView=footerView;
        }else{
            footerView.backgroundColor=[UIColor whiteColor];
            button.frame=CGRectMake((kkDeviceWidth-125)/2, 20, 125, 40);
            [button setTitle:@"查看所有样品" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(sampleBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _sampleTableView.tableFooterView=footerView;
        }
    }
}
//TODO:书家信息
- (void)downloadPenmanInfo
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetPenmanDetail" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_penmanID forKey:@"PMID"];
    [parameterDic setValue:_personalModel.UserID.length==0?@"0":_personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"]){
                _detailModel=[[PenmanDetailModel alloc]init];
                [_detailModel setValuesForKeysWithDictionary:dic];
                
                NSMutableArray *tempArr=[[NSMutableArray alloc]init];
                for(NSDictionary *subDic in dic[@"Evaluation"]){
                    PenmanDetailCommentModel *model=[[PenmanDetailCommentModel alloc]init];
                    [model setValuesForKeysWithDictionary:subDic];
                    NSMutableArray *imageArr=[[NSMutableArray alloc]init];
                    for(NSDictionary *imageDic in subDic[@"ImageData"]){
                        [imageArr addObject:imageDic[@"EPicPath"]];
                    }
                    model.ImageDataArr=[imageArr copy];
                    
                    [tempArr addObject:model];
                }
                
                _detailModel.EvaluationArr=[tempArr copy];
                [tempArr removeAllObjects];
                for(NSDictionary *subDic in dic[@"Sample"]){
                    PenmanDetailSampleModel *model=[[PenmanDetailSampleModel alloc]init];
                    [model setValuesForKeysWithDictionary:subDic];
                    [tempArr addObject:model];
                    
                }
                _detailModel.SampleArr=[tempArr copy];
                
                [tempArr removeAllObjects];

                for(NSDictionary *subDic in dic[@"Coupon"])
                {
                    CouponMopinModel *model=[[CouponMopinModel alloc]init];
                    [model setValuesForKeysWithDictionary:subDic];
                    model.Source=_detailModel.TrueName;
                    [tempArr addObject:model];
                }
                _detailModel.CouponArr=[tempArr copy];
            }
            [self resetUI];
        }
    } failure:^(NSError *error){
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
- (void)resetUI
{
    /*公益作品相关处理*/
    _publicFreeIcon.hidden = YES;
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState] isEqualToString:@"1"])
    {
        /*书家列表公益标签*/
        if([_detailModel.IsPublicGoodPM isEqualToString:@"0"])
        {
            _publicFreeIcon.hidden = YES;
            
        }else{
            
            if([_detailModel.IsPublicGoodPM isEqualToString:@"1"])
            {
                _publicFreeIcon.image = [UIImage imageNamed:@"red_sign"];
                _publicFreeIcon.hidden = NO;
                
            }else if([_detailModel.IsPublicGoodPM isEqualToString:@"2"])
            {
                _publicFreeIcon.image = [UIImage imageNamed:@"gray"];
                _publicFreeIcon.hidden = NO;
            }
        }
        
    }else{
        
        _publicFreeIcon.hidden = YES;
    }
    CGRect frame;
    
    _bgScrollView.hidden=NO;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.BackPic] placeholderImage:mImageByName(PlaceHeaderRectangularImage)];
    _nameLabel.text=[NSString stringWithFormat:@"%@",_detailModel.TrueName];
    //笔名不存在的时候
    if(_detailModel.PenName.length==0){
        _penmanLabel.hidden=YES;
    }else{
        _penmanLabel.hidden=NO;
        _penmanLabel.text=[NSString stringWithFormat:@"（%@）",_detailModel.PenName];
        
        
    }
    if(_detailModel.IsAttend.intValue==1){
        [_attentionBtn setTitle:[NSString stringWithFormat:@"关注 %@",_detailModel.AttendNum] forState:UIControlStateNormal];
    }else{
        [_attentionBtn setTitle:[NSString stringWithFormat:@"已关注 %@",_detailModel.AttendNum] forState:UIControlStateNormal];
    }
    
    CGFloat width=21*3;
    CGFloat x;
    if(_detailModel.UserType.intValue==3){
        _iconImage1.image=[UIImage imageNamed:@"ming_penmanList.png"];
        x=26;
    }else if(_detailModel.UserType.intValue==4){
        _iconImage1.image=[UIImage imageNamed:@"big_penmanList.png"];
        x=26;
    }else{
        _iconImage1.hidden=YES;
        width=width-21;
        x=0;
    }
    
    if(_detailModel.IsBooked.intValue==0){
        _iconImage2.hidden=YES;
        width=width-21;
    }else{
        x=x+26;
    }
    if(_detailModel.Trend.intValue==-1){
        _iconImage3.image=[UIImage imageNamed:@"down_icon_penmanList.png"];
    }else if(_detailModel.Trend.intValue==0){
        _iconImage3.image=[UIImage imageNamed:@"right_icon_penmanList.png"];
    }else if(_detailModel.Trend.intValue==1){
        _iconImage3.image=[UIImage imageNamed:@"up_icon_penmanList.png"];
    }
    
    //如果有3个加2个间距
    if(width==63){
        width+=10;
    }else if(width==42){//如果有2个加1个间距
        width+=5;
    }
    frame=_iconImage1.frame;
    frame.origin.x=_iconImage1.hidden?(kkDeviceWidth-width)/2-GETVIEWWIDTH(_iconImage1):(kkDeviceWidth-width)/2;
    _iconImage1.frame=frame;
    
    frame=_iconImage2.frame;
    frame.origin.x=_iconImage2.hidden?CGRectGetMaxX(_iconImage1.frame)-GETVIEWWIDTH(_iconImage2):CGRectGetMaxX(_iconImage1.frame);
    _iconImage2.frame=frame;
    
    frame=_iconImage3.frame;
    frame.origin.x=CGRectGetMaxX(_iconImage2.frame)+5;
    _iconImage3.frame=frame;
    
//    _attentionBtn setTitle:[NSString stringWithFormat:@"关注%@",_detailModel.] forState:<#(UIControlState)#>
//    _infoLabel.text=_detailModel.Intro;
    _priceLabel.text=[NSString stringWithFormat:@"润格 %@元/平尺    均价 %@元/件",_detailModel.NPrice,_detailModel.AveragePrice];
    [_commentCountBtn setTitle:[NSString stringWithFormat:@"%@ 条评价",_detailModel.EvaluationNum] forState:UIControlStateNormal];
    [_sampleCountBtn setTitle:[NSString stringWithFormat:@"%@ 副样品",_detailModel.SampleNum] forState:UIControlStateNormal];
    
    NSMutableAttributedString *infoAttrbutedString=[[NSMutableAttributedString alloc]initWithString:_detailModel.Intro];
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing=15;
    [infoAttrbutedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _detailModel.Intro.length)];
    _infoLabel.attributedText=infoAttrbutedString;
    
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[_infoLabel.attributedText.string boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_infoLabel.font} context:nil].size.height;
    }else{
        height=[_infoLabel.attributedText.string sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    frame=_infoLabel.frame;
    frame.size.height=height;
    _infoLabel.frame=frame;
    
    frame=_priceLabel.frame;
    frame.origin.y=CGRectGetMaxY(_infoLabel.frame)+50;
    _priceLabel.frame=frame;
    
    frame=_infoBgView.frame;
    frame.size.height=CGRectGetMaxY(_priceLabel.frame)+30;
    _infoBgView.frame=frame;
    
    if(_detailModel.EvaluationArr.count==0){
        _commentTableView.hidden=YES;
    }else{
//        height=55;
        _commentTipLabel.hidden=YES;
        [_commentTableView reloadData];
        
        frame=_commentTableView.frame;
        frame.size.height=_commentTableView.contentSize.height;
        _commentTableView.frame=frame;
    }
    
    frame=_commentBgView.frame;
    frame.origin.y=CGRectGetMaxY(_infoBgView.frame);
    frame.size.height=CGRectGetMaxY(_commentTableView.frame);
    _commentBgView.frame=frame;
    
    if(_detailModel.SampleArr.count==0){
        _sampleTableView.hidden=YES;
    }else{
        _sampleTipLabel.hidden=YES;
        [_sampleTableView reloadData];
        
        frame=_sampleTableView.frame;
        frame.size.height=_sampleTableView.contentSize.height;
        
        //可定制数量为0
        if(_detailModel.StockNum.intValue==0 && _detailModel.noncommercialstock.intValue==0){
            _stackNumTipLabel.hidden=NO;
            _stackNumTipLabel.text=@"很遗憾，该书家暂不接受定制";
            frame.origin.y=80;
        }else if(_detailModel.StockNum.intValue==0 && _detailModel.noncommercialstock.intValue!=0){
            _stackNumTipLabel.hidden=NO;
            _stackNumTipLabel.text=@"很遗憾，该书家暂不接受商业定制";
            frame.origin.y=80;
        }else if(_detailModel.StockNum.intValue!=0 && _detailModel.noncommercialstock.intValue==0){
            _stackNumTipLabel.hidden=NO;
            _stackNumTipLabel.text=@"很遗憾，该书家暂不接受公益定制";
            frame.origin.y=80;
        }else{
            _stackNumTipLabel.hidden=YES;
            frame.origin.y=57;
        }
        _sampleTableView.frame=frame;
    }
    frame=_sampleBgView.frame;
    frame.origin.y=CGRectGetMaxY(_commentBgView.frame);
    frame.size.height=CGRectGetMaxY(_sampleTableView.frame);
    _sampleBgView.frame=frame;
    
    if(_detailModel.CouponArr.count!=0){
        _couponTipLabel.hidden=YES;
        [_couponTableView reloadData];
        
        frame=_couponTableView.frame;
        frame.size.height=_couponTableView.contentSize.height;
        _couponTableView.frame=frame;
    }
    frame=_couponBgView.frame;
    frame.size.height=CGRectGetMaxY(_couponTableView.frame)+40;
    frame.origin.y=CGRectGetMaxY(_sampleBgView.frame);
    _couponBgView.frame=frame;
    
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_couponBgView.frame));
}
//TODO:查看所有样品
- (void)sampleBtnClick{
    
    AllSampleViewController *alvc=[[AllSampleViewController alloc]init];
    alvc.penmanId=_penmanID;
    [self.navigationController pushViewController:alvc animated:YES];
}
//TODO:查看所有评价
- (void)commentBtnClick
{
    CustomCommentVC *ccvc=[[CustomCommentVC alloc]initWithType:0 AndTypeID:_penmanID];
    [self.navigationController pushViewController:ccvc animated:YES];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_commentTableView){
        return _detailModel.EvaluationArr.count;
    }else if(tableView==_sampleTableView){
        return _detailModel.SampleArr.count;
    }
    return _detailModel.CouponArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_commentTableView){
        PenmanDetailCommentModel *model;
        if(_detailModel.EvaluationArr.count!=0){
            model=_detailModel.EvaluationArr[indexPath.row];
        }
        return [EvaluteSampleCell getHeightWithModelInPenmanDetail:model];
    }else if(tableView==_sampleTableView){
        return 400.0f;
    }
    return 120.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_commentTableView){
        EvaluteSampleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"EvaluteSampleCell"];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"EvaluteSampleCell" owner:self options:nil]firstObject];
        }
        PenmanDetailCommentModel *model;
        if(_detailModel.EvaluationArr.count!=0){
            model=_detailModel.EvaluationArr[indexPath.row];
            cell.delegate=self;
        }
        [cell reloadPenmanDetailCommentWithModel:model];
        return cell;
    }else if(tableView==_sampleTableView){
        PenmanDetailSampleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PenmanDetailSampleCell"];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"PenmanDetailSampleCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        PenmanDetailSampleModel *model;
        if(_detailModel.SampleArr.count!=0){
            model=_detailModel.SampleArr[indexPath.row];
        }
        cell.model  = model;
        return cell;
    }
    FundCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FundCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"FundCell" owner:self options:nil]firstObject];
    }
    CouponMopinModel *model;
    if(_detailModel.CouponArr.count!=0){
        cell.delegate=self;
        model=_detailModel.CouponArr[indexPath.row];
    }
    [cell reloadCellInPenmanDetailWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_sampleTableView){
        __weak typeof(self) weakSelf=self;
        
        PenmanDetailSampleModel *model=_detailModel.SampleArr[indexPath.row];
        ExmapleWorkDetailVC *evc=[[ExmapleWorkDetailVC alloc]initWithArtID:model.ArtID AndArtPrice:model.Price PMID:_penmanID];
        [evc setRefreshPenmanDetail:^{
            [weakSelf downloadPenmanInfo];
        }];
        [self.navigationController pushViewController:evc animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
    if ([_commentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_commentTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_commentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_commentTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark - FundCellDelegate
- (void)getCouponWithModel:(CouponMopinModel *)model
{
    if(model.Type.intValue==1){
        [self attentionBtnClick:_attentionBtn];
        return;
    }
    if(model.Type.intValue==2){
        [self rightNavBtnClick];
        return;
    }
    
    if(!_personalModel.isLogin){
        [self login];
        return;
    }
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCoupon" forKey:@"Method"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:@"1" forKey:@"Type"];
    [parameterDic setValue:model.BatchID forKey:@"BatchID"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
//            NSInteger index= [_detailModel.CouponArr indexOfObject:model];
//            NSMutableArray *tempArr=[_detailModel.CouponArr mutableCopy];
//            [tempArr removeObjectAtIndex:index];
//            _detailModel.CouponArr=[tempArr copy];
            
//            [_couponTableView reloadData];
            [self reloadCouponWithType:3 andDeleteModel:model];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}

- (void)login
{
    LoginViewController *lvc=[[LoginViewController alloc]init];
    lvc.formVCTag=1;
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
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
