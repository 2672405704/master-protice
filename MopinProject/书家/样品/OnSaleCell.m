//
//  OnSaleCell.m
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "OnSaleCell.h"
#import "SampleModel.h"
#import "UIImageView+WebCache.h"

@interface OnSaleCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *publicIcon; //公益标识
@property (weak, nonatomic) IBOutlet UILabel *sampleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fundLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView1;   //上架样品按钮样式
@property (weak, nonatomic) IBOutlet UIButton *deleteBnt;//删除按钮or设置公益

@property (weak, nonatomic) IBOutlet UIView *bgView2;   //仓库样品按钮样式
@end

@implementation OnSaleCell

- (void)awakeFromNib {
    // Initialization code
    _leftImageView.contentMode=UIViewContentModeScaleAspectFill;
    _leftImageView.clipsToBounds=YES;
    
}
- (void)reloadCellWithType:(NSInteger)type
{
    _publicIcon.hidden = YES;
    if(type==1){
        _bgView1.hidden=NO;
        _bgView2.hidden=YES;
        _publicIcon.hidden = YES;
        /*一系列的判断*/
        if([[[PublicWelfareManager shareInstance]getPublicWelfareState] isEqualToString:@"1"]&&[[PersonalInfoSingleModel shareInstance].IsGoodPublic isEqualToString:@"1"])
        {
            if([_sampleModel.IsPublicGoodSample isEqualToString:@"0"]||_sampleModel.IsPublicGoodSample.length==0)
            {
                _publicIcon.hidden = YES;
            }
            if([_sampleModel.IsPublicGoodSample isEqualToString:@"1"])
            {
                _publicIcon.hidden = NO;
                _publicIcon.image = [UIImage imageNamed:@"red_sign"];
            }
            if([_sampleModel.IsPublicGoodSample isEqualToString:@"2"])
            {
                _publicIcon.hidden = NO;
                _publicIcon.image = [UIImage imageNamed:@"gary_sign"];
            }
            //公益按钮设置
            [_deleteBnt setTitle:@"设置公益" forState:UIControlStateNormal];
            [_deleteBnt setTitle:@"取消公益" forState:UIControlStateSelected];
            _deleteBnt.selected =  [_sampleModel.IsPublicGoodSample isEqualToString:@"1"];
        }

    }else{
        
        _publicIcon.hidden = YES;
        _bgView1.hidden=YES;
        _bgView2.hidden=NO;
    }
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_sampleModel.ArtPic] placeholderImage:[UIImage imageNamed:PlaceHeaderSquareImage]];
    _sampleTitleLabel.text=_sampleModel.Name;
    _typeLabel.text=[NSString stringWithFormat:@"%@ %@ %@*%@CM",_sampleModel.ShowType,_sampleModel.WordType,_sampleModel.SizeWidth,_sampleModel.SizeHigh];
    _fundLabel.text=[NSString stringWithFormat:@"本品可用券：%@%%",_sampleModel.CouponsRatio];
    _moneyLabel.text=_sampleModel.Price;
}
//TODO:编辑
- (IBAction)editBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(editSample:)]){
        [_delegate editSample:_sampleModel];
    }
}
//TODO:下架
- (IBAction)soldOutBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(soldOutSample:)]){
        [_delegate soldOutSample:_sampleModel];
    }
}
//TODO:删除||设置公益
- (IBAction)deleteBtnClick:(id)sender {
    UIButton *tmpBnt = (UIButton*)sender;
    
    if([tmpBnt.titleLabel.text isEqualToString:@"设置公益"]||[tmpBnt.titleLabel.text isEqualToString:@"取消公益"]){
        
        /*更改样品的公益状态*/
        [self changeSampleWithType:tmpBnt.isSelected?@"1":@"2" Button:tmpBnt];
        
        
    }else{
    
        if(_delegate && [_delegate respondsToSelector:@selector(deleteSample:)]){
            [_delegate deleteSample:_sampleModel];
          }
    
    }
}
//TODO:置顶
- (IBAction)stickBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(stickSample:)]){
        [_delegate stickSample:_sampleModel];
    }
}
//TODO:上架样品
- (IBAction)upStoreBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(upStoreSample:)]){
        [_delegate upStoreSample:_sampleModel];
    }
}

//TODO:更改样品的公益状态
//1:取消公益样品
//2：设置为公益样品
-(void)changeSampleWithType:(NSString*)type
                     Button:(UIButton*)sender
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SetPublicGoodSample" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_sampleModel.ArtID forKey:@"ArtID"];
    [parameterDic setValue:type forKey:@"IsCancel"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            //改变按钮，改变表示的状态
            sender.selected = !sender.isSelected;
            _publicIcon.hidden =!_publicIcon.isHidden;
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
        
    }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
