//
//  IfSignedVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "IfSignedVC.h"
#import "XHDHelper.h"

@protocol ChangeEnableSignDelegate <NSObject>

- (void)changeEnableSign:(BOOL)isEnabel;

@end

@interface ChooseisEnableSignedView : UIView
{
    UILabel *titleLab ;  //标题Lab
    UIButton *enableBnt;   //允许按钮
    UIButton *notEnableBnt; //不允许的按钮
   

}
@property (nonatomic, assign,getter=isEnableSigned)BOOL enableSiged;  //可题款
@property(nonatomic,weak)id<ChangeEnableSignDelegate> delegate;  //代理

@end

@implementation ChooseisEnableSignedView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //_enableSiged = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    //标题
    titleLab = [XHDHelper createLabelWithFrame:mRect(25, 10, 80,20) andText:@"是否题上款" andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor: MainFontColor];
    [self addSubview:titleLab];
    
    //否
    notEnableBnt = [XHDHelper createButton:mRect(titleLab.right+5, titleLab.origin.y, 80, titleLab.height) NomalTitle:@"否" SelectedTitle:@"否" NomalTitleColor:MainFontColor SelectTitleColor:THEMECOLOR_1 NomalImage:mImageByName(@"point_sample") SelectedImage:mImageByName(@"gou_red_sample") BoardLineWidth:0 target:self selector:@selector(changeChooseBnt:)];
    notEnableBnt.selected  = _enableSiged?NO:YES;
    notEnableBnt.titleLabel.font = UIFONT(14);
    [notEnableBnt setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [notEnableBnt setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self addSubview:notEnableBnt];
    
    //是
    enableBnt = [XHDHelper createButton:mRect(notEnableBnt.right+5, notEnableBnt.origin.y, 80,notEnableBnt.height) NomalTitle:@"是" SelectedTitle:@"是" NomalTitleColor:MainFontColor SelectTitleColor:THEMECOLOR_1 NomalImage:mImageByName(@"point_sample") SelectedImage:mImageByName(@"gou_red_sample") BoardLineWidth:0 target:self selector:@selector(changeChooseBnt:)];
    [enableBnt setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    enableBnt.selected = _enableSiged?YES:NO;
    [enableBnt setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    enableBnt.titleLabel.font = UIFONT(14);
    [self addSubview:enableBnt];
    
}
- (void) changeChooseBnt:(UIButton*)sender
{
    enableBnt.selected = NO;
    notEnableBnt.selected = NO;
    sender.selected = YES;
    if([sender isEqual:enableBnt])
    {
        _enableSiged = YES;
    }
    else{
       _enableSiged = NO;
    }
    
    
    if([_delegate respondsToSelector:@selector(changeEnableSign:)])
    {
        [_delegate changeEnableSign:_enableSiged];
    }
}
- (void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.5f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context,rect.size.width, rect.origin.y);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
    
}
@end

#pragma ifSignVC
@interface IfSignedVC ()<UITextViewDelegate,ChangeEnableSignDelegate>
{
   UIButton *commitBnt_1;
   UITextView *_commenttextView;
    ChooseisEnableSignedView *chooseView;
}
@end

@implementation IfSignedVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

   if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
   {
       [mNotificationCenter addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil]; //(即将显示)
       [mNotificationCenter addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil]; //(即将隐藏)
   }
    
    return self;
}

/*返回*/
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

#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"题款";
    [self setNavBackBtnWithTitle:@"取消"];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createIsSignView];
    [self createCommitButton];
    
}
#pragma mark -- 选择是否题款
- (void)createIsSignView
{
    //是否题款选择
    chooseView = [[ChooseisEnableSignedView alloc]initWithFrame:mRect(0,0, kkDeviceWidth, 40)];
    chooseView.delegate = self;
    chooseView.enableSiged = _inputContent.length?YES:NO;
    [self.view addSubview:chooseView];
    
    
    //题款内容
    UIView *textViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, chooseView.bottom, kkDeviceWidth,120)];
    textViewBg.backgroundColor = [UIColor whiteColor];
    
    _commenttextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, textViewBg.frame.size.width-20, textViewBg.frame.size.height-10)];
    _commenttextView.backgroundColor = [UIColor whiteColor];
    _commenttextView.editable = NO;
    _commenttextView.delegate = self;
    _commenttextView.keyboardType = UIKeyboardTypeDefault;
    _commenttextView.returnKeyType = UIReturnKeyDone;
    _commenttextView.text = _inputContent.length?_inputContent:@"请输入内容正文，如：贺张某某六十大寿...";
    _commenttextView.font = [UIFont systemFontOfSize:12.5];
    _commenttextView.textColor = [UIColor lightGrayColor];
    [textViewBg addSubview:_commenttextView];
    
    [self.view addSubview:textViewBg];
    _commenttextView.editable = chooseView.enableSiged ;

}
/*可否题款的代理方法*/
- (void)changeEnableSign:(BOOL)isEnabel
{
    _commenttextView.editable = isEnabel;
    if(_commenttextView.editable)
    {
        [_commenttextView becomeFirstResponder];
        
    }else{
        
        [_commenttextView resignFirstResponder];
    }
    
}


/*如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：*/
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入内容正文，如：贺张某某六十大寿..."])
    {
       textView.text=@"";
    }
    textView.textColor = MainFontColor;
    return YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.text = [XHDHelper delSpaceWith:textView.text];
    if (textView.text.length==0)
    {
        NSString *placeStr;
        placeStr =  @"请输入内容正文，如：贺张某某六十大寿...";
        textView.text = placeStr;
        textView.textColor = TipsFontColor;
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
   
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //该判断用于联想输入
    if(textView.text.length>30)
    {
        textView.text = [textView.text substringToIndex:30];
        [SVProgressHUD showErrorWithStatus:@"题款内容不能超过30个字"];
        
    }
}

#pragma mark-- 提交按钮
- (void)createCommitButton
{
    /*提交按钮*/
   commitBnt_1 = [XHDHelper getRedGeneralButtonWithFrame:mRect(0,kkDeviceHeight-109, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commitBnt_1.titleLabel.font = UIFONT_Tilte(16);
    [commitBnt_1 addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBnt_1.tag = 550;
    [self.view addSubview:commitBnt_1];

}
-(void)commitAction:(UIButton*)sender
{
    [self.view endEditing:YES];
    //然后将值传回去
    if([_delegate respondsToSelector:@selector(finishedChooseWorkIsTikuan:AndContent:)])
    {
         if(chooseView.isEnableSigned)
         {
             if(_commenttextView.text.length==0||[_commenttextView.text isEqualToString:@"请输入内容正文，如：贺张某某六十大寿..."])
             {
                 [SVProgressHUD showErrorWithStatus:@"请输入题款内容"];
                 return;
             }
             [_delegate finishedChooseWorkIsTikuan:YES AndContent:_commenttextView.text];
         }
         else
         {
             [_delegate finishedChooseWorkIsTikuan:NO AndContent:@""];
         }
    
    }
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark --- 键盘遮挡效果 --------------
- (void)keyBoardWillHide:(NSNotification *)info//(即将隐藏)
{
    [UIView animateWithDuration:0.25 animations:^{
        
        commitBnt_1.bottom = kkDeviceHeight-64;
    }];
}

- (void)keyBoardWillShow:(NSNotification *)info//(即将显示)
{
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
        commitBnt_1.bottom = kkDeviceHeight-offset-64;
    }];
    
}

@end
