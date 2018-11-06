//
//  CheckCustomRemarkVC.m
//  
//
//  Created by xhd945 on 16/1/8.
//
//

#import "CheckCustomRemarkVC.h"

@interface CheckCustomRemarkVC ()
{
    UIView *bgView;
    UILabel *liuYanLab;  //留言显示
    
}
@end

@implementation CheckCustomRemarkVC
- (instancetype)initWithContent:(NSString*)ContentStr
                      TitleName:(NSString*)titleName
{
    self = [super init];
    if (self) {
        
        _contentStr = ContentStr;
        _titleName = titleName;
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title= _titleName;
    [self setNavBackBtnWithType:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLiuYanLabel];
    
}

#pragma mark -- 留言Label
- (void)createLiuYanLabel
{
    bgView = [[UIView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, kkDeviceHeight*0.4)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    liuYanLab = [XHDHelper createLabelWithFrame:mRect(20, 10, bgView.width-40, 30) andText:_contentStr.length?_contentStr:@"" andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    liuYanLab.numberOfLines = 0;
    
    CGFloat height = [XHDHelper heightOfString:_contentStr font:liuYanLab.font maxSize:CGSizeMake(liuYanLab.width, 1000)].height;
    height = height>30?height:30;
    liuYanLab.height = height;
    bgView.height = liuYanLab.height>bgView.height-20?liuYanLab.height+20:bgView.height;
    [bgView addSubview:liuYanLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    if(liuYanLab==nil)
    {
        [self createLiuYanLabel];
    }
    liuYanLab.text = _contentStr;
    CGFloat height = [XHDHelper heightOfString:_contentStr font:liuYanLab.font maxSize:CGSizeMake(liuYanLab.width, 1000)].height;
    height = height>30?height:30;
    liuYanLab.height = height;
    bgView.height = liuYanLab.height>bgView.height-20?liuYanLab.height+20:bgView.height;
}

@end
