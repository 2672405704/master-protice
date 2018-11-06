//
//  ShowSampleViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/30.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ShowSampleViewController.h"
#import "RecommendContentModel.h"
#import "PublishSampleModel.h"
#import "SampleAttributeModel.h"
#import "CustomBannerView.h"
#import "ApplyPenmanSucessViewController.h"

@interface ShowSampleViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *percentBtn;
@property (weak, nonatomic) IBOutlet UILabel *mopinPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *introlLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIView *promotionBgView;

@property (weak, nonatomic) IBOutlet UILabel *promotionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *promotionLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *promotionLineImageView;
@property (weak, nonatomic) IBOutlet UILabel *promotoTipLabel; //赠送作品集

@property (weak, nonatomic) IBOutlet UIView *placeBgView;
@property (weak, nonatomic) IBOutlet UIView *offerBgView;

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation ShowSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"样品预览";
    [self setNavBackBtnWithType:1];
    
    [self initializeView];
    [self createScrollView];
}
//TODO:创建scrollView
- (void)createScrollView
{
//    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 250)];
//    scrollView.delegate=self;
////    scrollView.contentSize=CGSizeMake(kkDeviceWidth*_publishModel.SamplePicIDArr.count, 250);
//    [_imageBgView insertSubview:scrollView atIndex:0];
    CustomBannerView *bannerView=[[CustomBannerView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 250) WithImageArr:_publishModel.SamplePicArr];
    _imageCountLabel.text=[NSString stringWithFormat:@"1/%@",@(_publishModel.SamplePicArr.count)];
    bannerView.countLabel=_imageCountLabel;
    [_imageBgView insertSubview:bannerView atIndex:0];
}
//TODO:初始化View
- (void)initializeView
{
    _priceLabel.text=_publishModel.Price;
    _titleLabel.text=_publishModel.SampleName;
    _infoLabel.text=[NSString stringWithFormat:@"%@/%@/%@*%@CM",_publishModel.ShowTypeModel.AttributeName,_publishModel.WordTypeModel.AttributeName,_publishModel.SizeWidth,_publishModel.SizeHighet];
    [_percentBtn setTitle:[NSString stringWithFormat:@"可用券：%d%%",_publishModel.MPCouponPer.intValue+_publishModel.WCouponPer.intValue] forState:UIControlStateNormal];
    
    _mopinPercentLabel.text=[NSString stringWithFormat:@"墨品券 %@%%(￥%.02f)",_publishModel.MPCouponPer,_publishModel.Price.intValue*(_publishModel.MPCouponPer.intValue/100.0)];
    _bookPercentLabel.text=[NSString stringWithFormat:@"书家券 %@%%(￥%.02f)",_publishModel.WCouponPer,_publishModel.Price.intValue*(_publishModel.WCouponPer.intValue/100.0)];
    
    _introlLabel.text=_publishModel.Content;
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[_introlLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_introlLabel.font} context:nil].size.height;
    }else{
        height=[_introlLabel.text sizeWithFont:_introlLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    CGRect frame=_introlLabel.frame;
    frame.size.height=height+0.1;
    _introlLabel.frame=frame;
    
    frame=_topBgView.frame;
    frame.size.height=CGRectGetMaxY(_introlLabel.frame)+25;
    _topBgView.frame=frame;
    
    frame=_bgView.frame;
    frame.origin.y=CGRectGetMaxY(_topBgView.frame);
    _bgView.frame=frame;
    
    _praiseLabel.text=@"0";
    _collectionLabel.text=@"0";
    _saleLabel.text=@"0";
    
    //促销活动
    if(_publishModel.RWCoupon.length==0){
        _promotionLabel1.text=@"暂无返券活动";
    }else{
        _promotionLabel1.text=[NSString stringWithFormat:@"成功定制本书家样品后，返%@元书家券。",_publishModel.RWCoupon];
    }
    if(IOS7_AND_LATER){
        height=[_promotionLabel1.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_promotionLabel1.font} context:nil].size.height;
    }else{
        height=[_promotionLabel1.text sizeWithFont:_promotionLabel1.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    frame=_promotionLabel1.frame;
    frame.size.height=height;
    _promotionLabel1.frame=frame;
    
    frame=_promotionLineImageView.frame;
    frame.origin.y=CGRectGetMaxY(_promotionLabel1.frame)+30;
    _promotionLineImageView.frame=frame;
    
    if(_publishModel.SaleDesc.length==0){
        _promotionLabel2.text=@"暂无赠品";
    }else{
        _promotionLabel2.text=[NSString stringWithFormat:@"成功定制本书家样品后，赠送书家%@(一本)。",_publishModel.SaleDesc];
        
    }
    if(IOS7_AND_LATER){
        height=[_promotionLabel2.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_promotionLabel2.font} context:nil].size.height;
    }else{
        height=[_promotionLabel2.text sizeWithFont:_promotionLabel2.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    frame=_promotoTipLabel.frame;
    frame.origin.y=CGRectGetMaxY(_promotionLineImageView.frame)+30;
    _promotoTipLabel.frame=frame;
    
    frame=_promotionLabel2.frame;
    frame.size.height=height;
    frame.origin.y=CGRectGetMaxY(_promotoTipLabel.frame)+3;
    _promotionLabel2.frame=frame;
    
    frame=_promotionBgView.frame;
    frame.size.height=CGRectGetMaxY(_promotionLabel2.frame)+30;
    _promotionBgView.frame=frame;
    
    NSMutableArray *useArr=[NSMutableArray arrayWithArray:_publishModel.PlaceCodeArr];
    [useArr addObjectsFromArray:_publishModel.UsedCodeArr];
    
//    CGFloat space=(kkDeviceWidth-60-65*4)/3;
    CGFloat width=(kkDeviceWidth-60-30)/3;
    for(int i=0;i<useArr.count;i++){
        SampleAttributeModel *model=useArr[i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.AttributeName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setBackgroundImage:[UIImage imageNamed:@"select_kuang_sample.png"] forState:UIControlStateNormal];
        button.frame=CGRectMake(30+(width+10)*(i%3),80+i/3*(30+15), width, 30);
        button.userInteractionEnabled=NO;
        [_placeBgView addSubview:button];
    }
    frame=_placeBgView.frame;
    frame.size.height=(((useArr.count-1)/3)+1)*(35+15)-10+30+80;
    frame.origin.y=CGRectGetMaxY(_promotionBgView.frame);
    _placeBgView.frame=frame;
    
    NSArray *titleArr=@[@"字体",@"幅式",@"尺寸",@"内容",@"题款",@"纸张",@"装裱",@"创作周期"];
    for(int i=0;i<titleArr.count;i++){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30,60+35*i, 100, 35)];
        label.text=titleArr[i];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=toPCcolor(@"888888");
        
        UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(kkDeviceWidth-30-110, 60+35*i,110, 35)];
        rightLabel.textAlignment=NSTextAlignmentCenter;
//        rightLabel.backgroundColor=[UIColor blackColor];
        rightLabel.textColor=toPCcolor(@"ca3b2b");
        rightLabel.font=[UIFont systemFontOfSize:15];
        switch (i) {
            case 0:
                rightLabel.text=_publishModel.WordTypeModel.AttributeName;
                break;
            case 1:
                rightLabel.text=_publishModel.ShowTypeModel.AttributeName;
                break;
            case 2:
//                if([_publishModel.ShowTypeModel.AttributeName isEqualToString:@"对联"]){
//                    rightLabel.text=[NSString stringWithFormat:@"%@*%@*2CM",_publishModel.SizeWidth,_publishModel.SizeHighet];
//                }else{
                    rightLabel.text=[NSString stringWithFormat:@"%@*%@CM",_publishModel.SizeWidth,_publishModel.SizeHighet];
//                }
                break;
            case 3:
                rightLabel.text=[NSString stringWithFormat:@"%@-%@字",_publishModel.MinWordNum,_publishModel.MaxWordNum];
                break;
            case 4:
            {
                if(_publishModel.TiKuan.intValue==0){
                    rightLabel.text=@"不可题款";
                }else{
                    rightLabel.text=@"可题款";
                }
            }
                break;
            case 5:
                rightLabel.text=_publishModel.MaterialCodeModel.AttributeName;
                break;
            case 6:
                rightLabel.text=@"标准装裱";
                break;
            case 7:
                rightLabel.text=_publishModel.DeliveryTimeCodeModel.AttributeName;
                break;
            default:
                break;
        }
        
        UIImageView *imageView;
        if(i!=titleArr.count-1){
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 60+35*(i+1), kkDeviceWidth-60, 0.5)];
            imageView.image=[UIImage imageNamed:@"line_sample.png"];
            [_offerBgView addSubview:imageView];
        }
        [_offerBgView addSubview:rightLabel];
        [_offerBgView addSubview:label];
    }
    frame=_offerBgView.frame;
    frame.size.height=35*titleArr.count+60+30;
    frame.origin.y=CGRectGetMaxY(_placeBgView.frame);
    _offerBgView.frame=frame;
    
    frame=_bgView.frame;
    frame.size.height=CGRectGetMaxY(_offerBgView.frame);
    _bgView.frame=frame;
    
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_bgView.frame)+10);
}
- (IBAction)submitSample:(id)sender {
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SaveSample" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    if(_publishModel.ArtID.length==0){
        [parameterDic setValue:@"0" forKey:@"ArtID"];
    }else{
        [parameterDic setValue:_publishModel.ArtID forKey:@"ArtID"];
    }
    [parameterDic setValue:_publishModel.WordTypeModel.AttributeCode forKey:@"WordType"];
    [parameterDic setValue:_publishModel.ShowTypeModel.AttributeCode forKey:@"ShowType"];
    [parameterDic setValue:_publishModel.MinWordNum forKey:@"MinWordNum"];
    [parameterDic setValue:_publishModel.MaxWordNum forKey:@"MaxWordNum"];
    [parameterDic setValue:_publishModel.Content forKey:@"Content"];
    
    NSMutableArray *tempArr=[[NSMutableArray alloc]init];
    if(_publishModel.RCIDList.count==0){
        [parameterDic setValue:@"" forKey:@"RCIDList"];
    }else{
        for(RecommendContentModel *model in _publishModel.RCIDList){
            [tempArr addObject:model.RCID];
        }
        [parameterDic setValue:[tempArr componentsJoinedByString:@","] forKey:@"RCIDList"];
    }
    
    [parameterDic setValue:_publishModel.TiKuan forKey:@"TiKuan"];
    
    [tempArr removeAllObjects];
    for(SampleAttributeModel *model in _publishModel.PlaceCodeArr){
        [tempArr addObject:model.AttributeCode];
    }
    [parameterDic setValue:[tempArr componentsJoinedByString:@","] forKey:@"PlaceCode"];
    
    [tempArr removeAllObjects];
    for(SampleAttributeModel *model in _publishModel.UsedCodeArr){
        [tempArr addObject:model.AttributeCode];
    }
    [parameterDic setValue:[tempArr componentsJoinedByString:@","] forKey:@"UsedCode"];
    
    
    [parameterDic setValue:_publishModel.SamplePicID forKey:@"SamplePicID"];
    [parameterDic setValue:_publishModel.SampleName forKey:@"SampleName"];
    [parameterDic setValue:_publishModel.SizeWidth forKey:@"SizeWidth"];
    [parameterDic setValue:_publishModel.SizeHighet forKey:@"SizeHighet"];
    
    [parameterDic setValue:_publishModel.Recommendation forKey:@"Recommendation"];
    [parameterDic setValue:_publishModel.SaleDesc.length==0?@"":_publishModel.SaleDesc forKey:@"SaleDesc"];
    [parameterDic setValue:_publishModel.MaterialCodeModel.AttributeCode forKey:@"MaterialCode"];
    [parameterDic setValue:_publishModel.DeliveryTimeCodeModel.AttributeCode forKey:@"DeliveryTimeCode"];
    [parameterDic setValue:_publishModel.Price forKey:@"Price"];
    [parameterDic setValue:_publishModel.MPCouponPer  forKey:@"MPCouponPer"];
    [parameterDic setValue:_publishModel.WCouponPer  forKey:@"WCouponPer"];
    [parameterDic setValue:_publishModel.RWCoupon.length==0?@"":_publishModel.RWCoupon forKey:@"RWCoupon"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            if(personalModel.UserType.intValue>=2){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                ApplyPenmanSucessViewController *apsvc=[[ApplyPenmanSucessViewController alloc]initWithNibName:@"ApplyPenmanSucessViewController" bundle:nil];
                for(NSDictionary *dic in jsonObject[@"data"]){
                    apsvc.artID=dic[@"ArtID"];
                }
                [self.navigationController pushViewController:apsvc animated:YES];
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
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
