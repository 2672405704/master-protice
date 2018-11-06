//
//  IssueSampleViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "IssueSampleViewController.h"
#import "SampleAttributeModel.h"
#import "PublishSampleViewController.h"
#import "PublishSampleModel.h"
#import "ChooseSamplePicViewController.h"

@interface IssueSampleViewController ()
{
    UIScrollView *_bgScrollView;
    UIView *_bgView1;
    UIView *_bgView2;
    UILabel *_tipLbael;
    
    NSInteger _selectedFontIndex; //选择字体的下标
    NSInteger _selectedStyleIndex;//选择样式下标
    PublishSampleModel *_publishModel;
    
    NSMutableArray *_selectedPlaceArr;//选择场所
    NSMutableArray *_selectedApplicationArr;//选择用途
}
@end

@implementation IssueSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"发布样品";
    [self setNavBackBtnWithType:1];

    if(_type==0){
        _selectedFontIndex=-1;
        _selectedStyleIndex=-1;
        if(!_model){
            _publishModel=[[PublishSampleModel alloc]init];
        }else{
            _publishModel=_model;
        }
        [self downloadSampleAttributeList];
    }else{
        _selectedApplicationArr=[NSMutableArray array];
        _selectedPlaceArr=[NSMutableArray array];
        
        _publishModel=_model;
        [self createScrollView];
    }
}
//TODO:获取属性列表
- (void)downloadSampleAttributeList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetSampleAttributeList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            NSMutableDictionary *mutabDic=[NSMutableDictionary dictionary];
            for(NSDictionary *dic in jsonObject[@"data"]){
                NSMutableArray *mutableArr=[NSMutableArray array];
                for(NSDictionary *itemDic in dic[@"Item"]){
                    SampleAttributeModel *model=[[SampleAttributeModel alloc]init];
                    [model setValuesForKeysWithDictionary:itemDic];
                    
                    [mutableArr addObject:model];
                }
                [mutabDic setValue:mutableArr forKey:dic[@"AttrType"]];
            }
            _publishModel.attributeDic=mutabDic;
            //创建scrollView
            [self createScrollView];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
- (void)createModel
{
    if(_type==0){
        NSArray *tempArr=_publishModel.attributeDic[@"1"];
        for(SampleAttributeModel *model in tempArr){
            if([_publishModel.WordTypeModel.AttributeCode isEqualToString:model.AttributeCode]){
                _publishModel.WordTypeModel.AttributeName=model.AttributeName;
                
                [self chooseFont:(UIButton *)[_bgView1 viewWithTag:100+[tempArr indexOfObject:model]]];
                break;
            }
        }
        tempArr=_publishModel.attributeDic[@"2"];
        for(SampleAttributeModel *model in tempArr){
            if([_publishModel.ShowTypeModel.AttributeCode isEqualToString:model.AttributeCode]){
                _publishModel.ShowTypeModel.AttributeName=model.AttributeName;
                
                [self chooseStyle:(UIButton *)[_bgView2 viewWithTag:200+[tempArr indexOfObject:model]]];
                break;
            }
        }
    }else{
        NSArray *tempArr=_publishModel.attributeDic[@"3"];
        for(SampleAttributeModel *sampleModel in _publishModel.PlaceCodeArr){
            for(SampleAttributeModel *model in tempArr){
                if([sampleModel.AttributeCode isEqualToString:model.AttributeCode]){
                    sampleModel.AttributeName=model.AttributeName;
                    
                    [self chooseFont:(UIButton *)[_bgView1 viewWithTag:100+[tempArr indexOfObject:model]]];
                    break;
                }
            }
        }
        
       tempArr=_publishModel.attributeDic[@"4"];
        for(SampleAttributeModel *sampleModel in _publishModel.UsedCodeArr){
            for(SampleAttributeModel *model in tempArr){
                if([sampleModel.AttributeCode isEqualToString:model.AttributeCode]){
                    sampleModel.AttributeName=model.AttributeName;
                    
                    [self chooseStyle:(UIButton *)[_bgView2 viewWithTag:200+[tempArr indexOfObject:model]]];
                    break;
                }
            }
        }
    }
}
//TODO:创建scrollView
- (void)createScrollView
{
    _bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight)];
    [self.view addSubview:_bgScrollView];
    
    NSArray *titleArr=@[@[@"样品书体",@"样品幅式"],@[@"样品适合的场所",@"样品适合的用途"]];
    for(int i=0;i<2;i++){
        UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,50*i, kkDeviceWidth-60, 50)];
        tipLabel.text=titleArr[_type][i];
        tipLabel.font=[UIFont fontWithName:XiaoBiaoSong size:15];
        [_bgScrollView addSubview:tipLabel];
        if(i==1){
            _tipLbael=tipLabel;
        }
    }
    for(int i=0;i<2;i++){
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0,50+(50+1)*i, kkDeviceWidth, 1)];
        bgView.backgroundColor=[UIColor whiteColor];
        [_bgScrollView addSubview:bgView];
        
        if(i==0){
            _bgView1=bgView;
        }else{
            _bgView2=bgView;
        }
    }
    
    UIButton *boomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    boomBtn.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth,mTabBarHeight);
    boomBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [boomBtn setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [boomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:boomBtn];
    
    [boomBtn addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(_type==0){
        [self createButtonWithKey:@"1" andOtherKey:@"2"];
    }else if(_type==1){
        [self createButtonWithKey:@"3" andOtherKey:@"4"];
    }
}
//TODO:创建点击的按钮
- (void)createButtonWithKey:(NSString *)key1 andOtherKey:(NSString *)key2
{
    NSArray *fontArr=_publishModel.attributeDic[key1];
//    CGFloat space=(kkDeviceWidth-60-85*3)/2;
    CGFloat width=(kkDeviceWidth-60-20)/3;
    for(int i=0;i<fontArr.count;i++){
        SampleAttributeModel *model=fontArr[i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(30+(width+10)*(i%3), 23+i/3*(35+15), width, 35);
        [button setTitle:model.AttributeName forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gary_button_sample.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"red_button_sample.png"] forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.tag=100+i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView1 addSubview:button];
        
        [button addTarget:self action:@selector(chooseFont:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGRect frame=_bgView1.frame;
    frame.size.height=23*2+((fontArr.count-1)/3)*(35+15)+35;
    _bgView1.frame=frame;
    
    NSArray *styleArr=_publishModel.attributeDic[key2];
    for(int i=0;i<styleArr.count;i++){
        SampleAttributeModel *model=styleArr[i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.frame=CGRectMake(30+(width+10)*(i%3), 23+i/3*(35+15), width, 35);
        [button setTitle:model.AttributeName forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gary_button_sample.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"red_button_sample.png"] forState:UIControlStateSelected];
        button.tag=200+i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView2 addSubview:button];
        
        [button addTarget:self action:@selector(chooseStyle:) forControlEvents:UIControlEventTouchUpInside];
    }
    frame=_tipLbael.frame;
    frame.origin.y=CGRectGetMaxY(_bgView1.frame);
    _tipLbael.frame=frame;
    
    frame=_bgView2.frame;
    frame.size.height=23*2+((styleArr.count-1)/3)*(35+15)+35;
    frame.origin.y=CGRectGetMaxY(_tipLbael.frame);
    _bgView2.frame=frame;
    
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_bgView2.frame));
    
    if(_publishModel.ArtID.length!=0){
        [self createModel];
    }
}
//TODO:选择样式 或者用途
- (void)chooseStyle:(UIButton *)button
{
    if(_type==0){
        if(_selectedStyleIndex==button.tag-200){
            return;
        }
        if(_selectedStyleIndex!=-1){
            UIButton *selectedButton=(UIButton *)[self.view viewWithTag:200+_selectedStyleIndex];
            selectedButton.selected=NO;
        }
        button.selected=YES;
        _selectedStyleIndex=button.tag-200;
    }else{
        if([_selectedApplicationArr containsObject:@(button.tag-200)]){
            button.selected=NO;
            [_selectedApplicationArr removeObject:@(button.tag-200)];
        }else{
            button.selected=YES;
            [_selectedApplicationArr addObject:@(button.tag-200)];
        }
    }
}
//TODO:选择字体 或者场所
- (void)chooseFont:(UIButton *)button
{
    if(_type==0){
        if(_selectedFontIndex==button.tag-100){
            return;
        }
        if(_selectedFontIndex!=-1){
            UIButton *selectedButton=(UIButton *)[self.view viewWithTag:100+_selectedFontIndex];
            selectedButton.selected=NO;
        }
        button.selected=YES;
        _selectedFontIndex=button.tag-100;
    }else{
        if([_selectedPlaceArr containsObject:@(button.tag-100)]){
            button.selected=NO;
            [_selectedPlaceArr removeObject:@(button.tag-100)];
        }else{
            button.selected=YES;
            [_selectedPlaceArr addObject:@(button.tag-100)];
        }
        
    }
}
//TODO:点击下一步
- (void)nextStepClick
{
    if(_type==0){
        [self saveFont];
    }else if(_type==1){
        [self saveArea];
    }
    
}
//TODO:如果是选择字体
- (void)saveFont
{
    if(_selectedFontIndex==-1){
        [SVProgressHUD showErrorWithStatus:@"请选择字体"];
        return;
    }
    if(_selectedStyleIndex==-1){
        [SVProgressHUD showErrorWithStatus:@"请选择幅式"];
        return;
    }
    
    NSArray *fontArr=_publishModel.attributeDic[@"1"];
    _publishModel.WordTypeModel=fontArr[_selectedFontIndex];
    
    NSArray *styleArr=_publishModel.attributeDic[@"2"];
    _publishModel.ShowTypeModel=styleArr[_selectedStyleIndex];
    
    PublishSampleViewController *psvc=[[PublishSampleViewController alloc]init];
    psvc.publishModel=_publishModel;
    [self.navigationController pushViewController:psvc animated:YES];
}
//TODO:如果是场所和用途
- (void)saveArea
{
    if(_selectedPlaceArr.count==0){
        [SVProgressHUD showErrorWithStatus:@"请选择适合的场所"];
        return;
    }
    if(_selectedApplicationArr.count==0){
        [SVProgressHUD showErrorWithStatus:@"请选择适合的用途"];
        return;
    }
    
    NSArray *fontArr=_publishModel.attributeDic[@"3"];
    NSMutableArray *placeArr=[NSMutableArray array];
    for(NSNumber *number in _selectedPlaceArr){
        [placeArr addObject:fontArr[number.intValue]];
    }
    
    _publishModel.PlaceCodeArr=placeArr;
    
    NSArray *styleArr=_publishModel.attributeDic[@"4"];
    NSMutableArray *applicationArr=[NSMutableArray array];
    for(NSNumber *number in _selectedApplicationArr){
        [applicationArr addObject:styleArr[number.intValue]];
    }
    _publishModel.UsedCodeArr=applicationArr;
    
    ChooseSamplePicViewController *cspvc=[[ChooseSamplePicViewController alloc]initWithNibName:@"ChooseSamplePicViewController" bundle:nil];
    cspvc.publishModel=_publishModel;
    [self.navigationController pushViewController:cspvc animated:YES];
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
