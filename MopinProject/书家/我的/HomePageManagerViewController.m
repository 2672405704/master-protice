//
//  HomePageManagerViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "HomePageManagerViewController.h"
#import "MineListCell.h"
#import "HomePageManagerCell.h"
#import "Utility.h"
#import "EvaluateManagerViewController.h"
#import "InputNameViewController.h"
#import "BookIntroViewController.h"
#import "RunGridViewController.h"
#import "EmailViewController.h"
#import "PenmanMainInfoModel.h"
#import "UIImageView+WebCache.h"
#import "PenmanDetailViewController.h"

@interface HomePageManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    UIImage *_selectedImage;
    PenmanMainInfoModel *_infoModel;
    PersonalInfoSingleModel *_personalModel;
}
@end

@implementation HomePageManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"主页管理";
    [self setNavBackBtnWithType:1];
    _titleArr=@[@"主页背景图",@"真实姓名(笔名)",@"个人简介",@"润格",@"电子邮箱",@"评价管理"];
    _infoModel=[[PenmanMainInfoModel alloc]init];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    
    [self createTableView];
    [self donwloadInfo];
}
- (void)donwloadInfo
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetPenmanMainInfo" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            [_infoModel setValuesForKeysWithDictionary:jsonObject[@"data"][0]];
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:创建tableView
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth,80)];
    footerView.backgroundColor=[UIColor clearColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:19];
    [button setTitle:@"查看我的书家主页" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_mine.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(30, 25, kkDeviceWidth-60, 50);
    [footerView addSubview:button];
    
    [button addTarget:self action:@selector(penmanDetail) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView=footerView;
}
//TODO:查看书家主页
- (void)penmanDetail
{
    PenmanDetailViewController *pdvc=[[PenmanDetailViewController alloc]initWithNibName:@"PenmanDetailViewController" bundle:nil];
    pdvc.penmanID=_personalModel.UserID;
    [self.navigationController pushViewController:pdvc animated:YES];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 85.0f;
    }
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        HomePageManagerCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"HomePageManagerCell" owner:self options:nil]firstObject];
        cell.titleLabel.text=_titleArr[indexPath.row];
        if(!_selectedImage){
            [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_infoModel.PicPath] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
        }else{
            cell.rightImageView.image=_selectedImage;
        }
        
        return cell;
    }
    MineListCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    cell.titleLabel.text=_titleArr[indexPath.row];
    cell.rightLabel.hidden=NO;
    cell.rightLabel.textColor=toPCcolor(@"888888");
    if(indexPath.row==1){
        if(_infoModel.Penname.length!=0){
            cell.rightLabel.text=[NSString stringWithFormat:@"%@(%@)",_infoModel.TrueName,_infoModel.Penname];
        }else if (_infoModel.TrueName.length!=0){
            cell.rightLabel.text=[NSString stringWithFormat:@"%@",_infoModel.TrueName];
        }
    }else if(indexPath.row==2){
        if(_infoModel.Intro.length!=0){
            cell.rightLabel.text=_infoModel.Intro;
        }
    }else if(indexPath.row==3){
        if(_infoModel.NPrice.length!=0){
            cell.rightLabel.text=[NSString stringWithFormat:@"%@元/平尺",_infoModel.NPrice];
        }
    }else if(indexPath.row==4){
        if(_infoModel.Email.length!=0){
            cell.rightLabel.text=_infoModel.Email;
        }
    }else{
        cell.rightLabel.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [sheet showInView:self.view];
    }else if(indexPath.row==1){
        InputNameViewController *invc=[[InputNameViewController alloc]initWithNibName:@"InputNameViewController" bundle:nil];
        invc.model=_infoModel;
        [invc setInputName:^() {
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:invc animated:YES];
    }else if(indexPath.row==2){
        BookIntroViewController *bivc=[[BookIntroViewController alloc]initWithNibName:@"BookIntroViewController" bundle:nil];
        bivc.model=_infoModel;
        [bivc setInputIntro:^() {
            
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:bivc animated:YES];
    }else if(indexPath.row==3){
        RunGridViewController *rgvc=[[RunGridViewController alloc]initWithNibName:@"RunGridViewController" bundle:nil];
        rgvc.model=_infoModel;
        [rgvc setInputRunGrid:^() {
            
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:rgvc animated:YES];
    }else if(indexPath.row==4){
        EmailViewController *evc=[[EmailViewController alloc]initWithNibName:@"EmailViewController" bundle:nil];
        evc.model=_infoModel;
        [evc setConfirmEmail:^(NSString *email) {
            
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:evc animated:YES];
    }else if(indexPath.row==5){
        EvaluateManagerViewController *emvc=[[EvaluateManagerViewController alloc]init];
        [self.navigationController pushViewController:emvc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    if(buttonIndex==0){
        //选择相机
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }else{
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            return;
        }
    }else if(buttonIndex==2){
        return;
    }
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取image
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    image=[self fixOrientation:image];
    
    [self uploadHeaderImageView:UIImageJPEGRepresentation(image,0.5)];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//TODO:处理图片旋转问题
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
//TODO:上传图片
- (void)uploadHeaderImageView:(NSData *)data
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SavePic" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod uploadImageWithParameters:parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *strname = [NSString stringWithFormat:@"%@.png",[Utility stringWithUUID]];
        [formData appendPartWithFileData:data name:@"file" fileName:strname mimeType:@"image/png"];
    } SuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * mssg = responseObject[@"msg"];
        NSInteger code = [responseObject[@"code"] integerValue];
        [DictionaryTool showResult:mssg withCode:code];
        
        if(code==1000){
            
            _selectedImage=[UIImage imageWithData:data];
            [_tableView reloadData];
            NSString *picID = responseObject[@"data"][@"ID"];
            [self SaveBackGroundImageWithPicID:picID];
        }
        
    } FailBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadFail:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)SaveBackGroundImageWithPicID:(NSString*)picID
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MainSaveBackPic" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:picID.length?picID:@"0" forKey:@"PicID"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}

@end
