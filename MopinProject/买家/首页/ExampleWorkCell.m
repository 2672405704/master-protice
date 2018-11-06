//
//  ExampleWorkCell.m
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ExampleWorkCell.h"
#import "ExampleWorkModel.h"
#import "PenmanDetailViewController.h"
#import "UIKit+AFNetworking.h"

@implementation ExampleWorkCell

-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,0.5f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height-10+0.5);
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height-10+0.5);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    /*
     * @kCGPathFill, 设置填充
     * @kCGPathStroke, 设置线条
     * @kCGPathFillStroke, 两者兼有
     */

}
- (void)awakeFromNib {
    
    [self setClipsToBounds:YES];
    _workPicture.contentMode=UIViewContentModeScaleAspectFill;
    _workPicture.clipsToBounds=YES;
    /*在大图底部画一根线*/
    [XHDHelper addDivLineWithFrame:mRect(0, _workPicture.height-0.5,mScreenWidth, 0.5) SuperView:_workPicture];
    
    
    _personHeaderIcon.layer.cornerRadius = _personHeaderIcon.height/2.0;
    _personHeaderIcon.clipsToBounds = YES;
    _personHeaderIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _personHeaderIcon.layer.borderWidth = 1.5;
    /*点击头像跳到书家主页*/
    _personHeaderIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkPenmanDetail:)];
    [_personHeaderIcon addGestureRecognizer:tap];
    
    _enableJuan.layer.cornerRadius = 5;
    _enableJuan.layer.borderWidth = 0.4;
    _enableJuan.layer.borderColor = THEMECOLOR_1.CGColor;
    _enableJuan.textColor = THEMECOLOR_1;
    
    _TitleLab.font = UIFONT_Tilte(19);
    [_priceLab adjustsFontSizeToFitWidth];
    [_TitleLab adjustsFontSizeToFitWidth];

}
-(void)layoutSubviews
{
      _publicIcon.hidden = YES;
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState] isEqualToString:@"1"])
    {
        if([_mod.IsPublicGoodSample isEqualToString:@"0"]||_mod.IsPublicGoodSample.length==0)
        {
            _publicIcon.hidden = YES;
        }
        if([_mod.IsPublicGoodSample isEqualToString:@"1"])
        {
            _publicIcon.hidden = NO;
            _publicIcon.image = [UIImage imageNamed:@"red_sign"];
        }
        if([_mod.IsPublicGoodSample isEqualToString:@"2"])
        {
            _publicIcon.hidden = NO;
            _publicIcon.image = [UIImage imageNamed:@"gary_sign"];
        }
    }

}
//TODO:设置View
- (void)resetView
{
    [_priceLab adjustsFontSizeToFitWidth];
    [_TitleLab adjustsFontSizeToFitWidth];
    if(_mod)
    {
        [_workPicture setImageWithURL:[NSURL URLWithString:self.mod.ArtPic] placeholderImage:mImageByName(PlaceHeaderRectangularImage)];
        [_personHeaderIcon setImageWithURL:[NSURL URLWithString:_mod.Photo] placeholderImage:mImageByName(PlaceHeaderIconImage)];
        _priceLab.text = [NSString stringWithFormat:@"%ld",_mod.Price.integerValue];
        _TitleLab.text = _mod.ArtName.length?_mod.ArtName:@"";
        _enableJuan.text = [NSString stringWithFormat:@"可用劵：%@%%",_mod.CouponsRatio];
        _attributeLab.text = [NSString stringWithFormat:@"%@/%@/%@",_mod.ShowType.length?_mod.ShowType:@"",_mod.WordType.length?_mod.WordType:@"",_mod.Size.length?_mod.Size:@""];
    }
}
//TODO:样品列表
- (void)reloadCellExampleList
{
    [self resetView];
}
//TODO:搜索样品
- (void)reloadCellSearchSampleList{
    
    self.backgroundColor=THEME_BG_COLOR;
    
#warning 有待确定
    _workPicture.frame=CGRectMake(0,0,CGRectGetWidth(self.frame),186);
   CGRect frame=_priceBgView.frame;
    frame.origin.x=0;
    _priceBgView.frame=frame;
    
    [self resetView];
}
- (IBAction)collectionCancelBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(cancelCollectionWithModel:)]){
        [_delegate cancelCollectionWithModel:_mod];
    }
}

/**
 * TODO:查看书家详情
 *
 *  @return nil
 */
-(void)checkPenmanDetail:(UITapGestureRecognizer*)tap
{
    
    if(_target &&_target.navigationController)
    {
        PenmanDetailViewController *PenmanDetail = [[PenmanDetailViewController alloc]init];
        PenmanDetail.penmanID = _mod.PMID;
        
        [self.target.navigationController pushViewController:PenmanDetail animated:YES];

        }

}
//TODO:收藏样品
- (void)reloadCellCollectionSampleList
{
    self.backgroundColor=THEME_BG_COLOR;
    _bottomBtnBgView.hidden=NO;
    [self resetView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
