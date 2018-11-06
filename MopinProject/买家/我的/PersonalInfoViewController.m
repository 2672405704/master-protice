//
//  PersonalInfoViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "HomePageManagerCell.h"
#import "MineListCell.h"
#import "Utility.h"
#import "ChangeNicknameViewController.h"
#import "SelectedSexView.h"
#import "ChooseDateView.h"
#import "ChooseAddressView.h"
#import "ChangePhoneViewController.h"
#import "UIImageView+WebCache.h"
#import "CityModel.h"
#import "AddressDataCenter.h"
#import "MyTabBarController.h"
#import "ShareTools.h"
#import "JPUSHService.h"

@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,SelectedSexViewDelegate,ChooseDateViewDelegate,ChooseAddressViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    UIImage *_selectedImage;
    SelectedSexView *_sexView;
    ChooseDateView *_dateView;
    ChooseAddressView *_addressView;
    PersonalInfoSingleModel *_personalModel;
    AddressDataCenter *_addressDC;
}
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBackBtnWithType:1];
    self.navigationItem.title=@"个人信息";
    
    _titleArr=@[@[@"头像",@"昵称",@"性别",@"出生日期",@"手机号",@"地区"],@[@"退出登录"]];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    _addressDC=[AddressDataCenter sharedInstance];
    
    [self createTableView];
}
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
        return 85.0f;
    }
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0){
        return 10.0f;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 10)];
    footerView.backgroundColor=self.view.backgroundColor;
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
        HomePageManagerCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"HomePageManagerCell" owner:self options:nil]firstObject];
        cell.titleLabel.text=_titleArr[indexPath.section][indexPath.row];
        cell.rightImageView.layer.cornerRadius=cell.rightImageView.frame.size.width/2;
        cell.rightImageView.layer.masksToBounds=YES;
        if(_selectedImage){
            cell.rightImageView.image=_selectedImage;
        }else{
            if(_personalModel.Photo.length!=0){
                [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_personalModel.Photo] placeholderImage:mImageByName(PlaceHeaderImage)];
            }else{
                cell.rightImageView.image=mImageByName(PlaceHeaderImage);
            }
        }
        return cell;
    }
    MineListCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    cell.titleLabel.text=_titleArr[indexPath.section][indexPath.row];
    cell.rightLabel.hidden=NO;
    cell.rightLabel.textColor=toPCcolor(@"888888");
    if(indexPath.row==1){
        if(_personalModel.NickName.length!=0){
            cell.rightLabel.text=_personalModel.NickName;
        }
    }else if(indexPath.row==2){
        if(_personalModel.Sex.intValue!=0){
            if(_personalModel.Sex.intValue==1){
                cell.rightLabel.text=@"男";
            }else{
                cell.rightLabel.text=@"女";
            }
        }
    }else if(indexPath.row==3){
        if(_personalModel.Birthday.length!=0){
            cell.rightLabel.text=_personalModel.Birthday;
        }
    }else if(indexPath.row==4){
        if(_personalModel.Phone.length!=0){
            cell.rightLabel.text=_personalModel.Phone;
        }
    }else if(indexPath.row==5){
        if(_personalModel.CityID.length!=0){
            cell.rightLabel.text=[_addressDC getProvinceNameWith:_personalModel.ProvinceID andCityName:_personalModel.CityID];
        }
    }else{
        cell.rightLabel.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row==0){
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"您确定要退出吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
        
    }else if(indexPath.row==0){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [sheet showInView:self.view];
    }else if(indexPath.row==1){
        __weak typeof(self) weakSelf=self;
        ChangeNicknameViewController *cnvc=[[ChangeNicknameViewController alloc]initWithNibName:@"ChangeNicknameViewController" bundle:nil];
        [cnvc setChangeNickName:^{
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            weakSelf.reloadInfo();
        }];
        [self.navigationController pushViewController:cnvc animated:YES];
    }else if(indexPath.row==2){
        if(!_sexView){
            _sexView=[[[NSBundle mainBundle] loadNibNamed:@"SelectedSexView" owner:self options:nil]firstObject];
            _sexView.delegate=self;
        }else{
            _sexView.hidden=NO;
        }
//        [self.view addSubview:sexView];
    }else if(indexPath.row==3){
        if(!_dateView){
            _dateView=[[ChooseDateView alloc]initViewWithType:2];
            _dateView.delegate=self;
            [WINDOW addSubview:_dateView];
        }else{
            _dateView.hidden=NO;
        }
        
    }else if(indexPath.row==4){
        ChangePhoneViewController *cpvc=[[ChangePhoneViewController alloc]initWithNibName:@"ChangePhoneViewController" bundle:nil];
        [cpvc setChangePhone:^{
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:cpvc animated:YES];
    }else if(indexPath.row==5){
        if(!_addressView){
            _addressView=[[ChooseAddressView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight) andProvince:_personalModel.ProvinceID andCity:_personalModel.CityID andDistrict:_personalModel.DistrictID];
            _addressView.delegate=self;
            [WINDOW addSubview:_addressView];
        }else{
            _addressView.hidden=NO;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        return;
    }
    [ShareTools logOut];
    MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:3];
    [self presentViewController:mtbc animated:YES completion:^{
        WINDOW.rootViewController=mtbc;
    }];
    [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }];
    
    return;
}
#pragma mark - ChooseDateView delegate
- (void)chooseDate:(NSString *)date
{
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - SelectedSexView delegate
- (void)selectedSex
{
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - ChooseAddressView delegate
- (void)chooseAddressIdWithArray:(NSArray *)arr
{
    CityModel *cityModel=arr[1];
    CityModel *proviceModel=arr[0];
    CityModel *districtModel=arr[2];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ChangeArea" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:proviceModel.Id forKey:@"ProvinceID"];
    [parameterDic setValue:cityModel.Id forKey:@"CityID"];
    [parameterDic setValue:districtModel.Id forKey:@"DistrictID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            _personalModel.CityID=cityModel.Id;
            _personalModel.ProvinceID=proviceModel.Id;
            _personalModel.DistrictID=districtModel.Id;
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:_personalModel.CityID forKey:@"CityID"];
            [infoDic setValue:_personalModel.ProvinceID forKey:@"ProvinceID"];
            [infoDic setValue:_personalModel.DistrictID forKey:@"DistrictID"];
            
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
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
    picker.allowsEditing=YES;
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
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    image=[self fixOrientation:image];
    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(120.0f,120.0f)];
    [self uploadHeaderImageView:UIImagePNGRepresentation(smallImage)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SaveUserPhoto" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod uploadHeadImageWithParameters:parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *strname = [NSString stringWithFormat:@"%@.png",[Utility stringWithUUID]];
        [formData appendPartWithFileData:data name:@"file" fileName:strname mimeType:@"image/png"];
    } SuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * mssg = responseObject[@"msg"];
        NSInteger code = [responseObject[@"code"] integerValue];
        [DictionaryTool showResult:mssg withCode:code];
        if(code==1000){
            _selectedImage=[UIImage imageWithData:data];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];


               _personalModel.Photo=responseObject[@"data"][@"Image"];

        
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:_personalModel.Photo forKey:@"Photo"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            self.reloadInfo();
        }
    } FailBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadFail:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
    }];
}
- (void)dealloc
{
    [_sexView removeFromSuperview];
    [_dateView removeFromSuperview];
    [_addressView removeFromSuperview];
    _addressView=nil;
    _dateView=nil;
    _sexView=nil;
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
