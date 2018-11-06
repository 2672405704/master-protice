//
//  OrderInfoView_second.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "OrderInfoView_second.h"
#import "XHDHelper.h"
#import "TextEditVC.h"
#import "ComfireOrderVC.h"
#import "MyOrderDetailVC.h"
#import "CheckCustomRemarkVC.h"

@implementation OrderInfoView_second
{
    UILabel *numberTitle; //订单数量
    UILabel *customLiuYan; //买家留言
    UITextField *numberChooseButton; //数量选择Button
    UILabel *liuYanContent; //留言内容
    UIView *maskView;  //遮罩视图
    UIButton *arrowIcon;  //又箭头
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initUI];
        _enableCheck = YES;
    }
    return self;
}


- (void)setEnableCheck:(BOOL)enableCheck
{
   if(enableCheck != _enableCheck)
   {
       _enableCheck = enableCheck;
   }
    if(_enableCheck)
    {
        if(maskView)
        {
          [maskView removeFromSuperview];
           maskView = nil;
        }
        
    }else{
    
        if(!maskView)
        {
            maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            maskView.backgroundColor = [UIColor clearColor];
            [self addSubview:maskView];
        }
    
    }
}
#pragma mark -- 画分割线
-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.0f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context,rect.size.width, rect.origin.y);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    CGContextSetLineWidth(context,0.5f);
    CGContextMoveToPoint(context,rect.origin.x+25, rect.size.height/2.0);
    CGContextAddLineToPoint(context,rect.size.width-25, rect.size.height/2.0);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
}

-(void)_initUI
{
    
    self.backgroundColor = [UIColor whiteColor];
    numberTitle = [XHDHelper createLabelWithFrame:mRect(25, 0, 80, 40) andText:@"定制数量" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:numberTitle];
    
    customLiuYan = [XHDHelper createLabelWithFrame:mRect(25, 40, 80, 40) andText:@"买家留言" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:customLiuYan];
    
    numberChooseButton  =  [[UITextField alloc]initWithFrame:mRect(0, 0, 60, 40)];
    numberChooseButton.delegate = self;
    numberChooseButton.textColor = MainFontColor;
    numberChooseButton.text = @"1";
    numberChooseButton.textAlignment = NSTextAlignmentRight;
    numberChooseButton.borderStyle = UITextBorderStyleNone;
    numberChooseButton.keyboardType = UIKeyboardTypeNumberPad;
    numberChooseButton.right = self.width-25;
    numberChooseButton.font = UIFONT(13.5);
    /*暂时屏蔽*/
    numberChooseButton.enabled = NO;
    numberChooseButton.textColor = MainFontColor;
    [self addSubview:numberChooseButton];
    [XHDHelper addToolBarOnInputFiled:numberChooseButton Action:@selector(textFildEndEdit) Target:self];
    
    
    liuYanContent = [XHDHelper createLabelWithFrame:mRect(25, 40, 150, 40) andText:_liuYanStr.length?_liuYanStr:@"(无)" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    
    liuYanContent.textAlignment = NSTextAlignmentRight;
    liuYanContent.right = self.width -45;
    [self addSubview:liuYanContent];
    liuYanContent.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoEditLiuYan:)];
    [liuYanContent addGestureRecognizer:tap];
    
    arrowIcon = [XHDHelper getRightArrowButtonWith:mRect(0, 52.5, 20, 15)];
    arrowIcon.right = self.width-20;
    [self addSubview:arrowIcon];
    arrowIcon.hidden = NO;
    
    self.height = 80;
}

-(void)updateUI
{
    /*处理*/
    [liuYanContent setText:_liuYanStr.length?(_liuYanStr.length>10?[XHDHelper replaceString:NSMakeRange(5, _liuYanStr.length-10) withString:_liuYanStr BaseStringMinLentgh:10]:_liuYanStr):@"(无)"];
}


#pragma mark -- 编辑买家留言
-(void)gotoEditLiuYan:(UITapGestureRecognizer*)tap
{
    if(self.delegate)
    {
        /*编辑*/
        if([self.delegate isMemberOfClass:[ComfireOrderVC class]])
        {
            _textvc = [[TextEditVC alloc]init];
            _textvc.titleName =  @"买家留言";
            _textvc.maxCount = 400;
            _textvc.text = _liuYanStr.length?_liuYanStr:nil;
            __weak typeof(liuYanContent) safeLiuYanLab = liuYanContent;
            _textvc.block = ^(NSString *liuyang)
            {
                /*留言过长就将中间的替换成"..."*/
                safeLiuYanLab.text = liuyang.length>8?[XHDHelper replaceString:NSMakeRange(4, liuyang.length-8) withString:liuyang BaseStringMinLentgh:8]:liuyang;
                
                _liuYanStr = liuyang;
            };
            
            [self.delegate.navigationController pushViewController:_textvc animated:YES];
        
        }
        /*查看*/
        else if([self.delegate isMemberOfClass:[MyOrderDetailVC class]])
        {
        
            CheckCustomRemarkVC *check = [[CheckCustomRemarkVC  alloc]initWithContent:_liuYanStr TitleName:@"买家留言"];
            [self.delegate.navigationController pushViewController:check animated:YES];
            
            NSLog(@"---%@----",_liuYanStr);
        }
        
    }
}

#pragma  mark -- textFildDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
   _chooseNumber = numberChooseButton.text;

}
-(void)textFildEndEdit
{
    [numberChooseButton resignFirstResponder];
    _chooseNumber = numberChooseButton.text;
}

@end
