//
//  ApplyMasterViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ApplyMasterViewController.h"
#import "Utility.h"
#import "PhotoManagerViewController.h"

@interface ApplyMasterViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_selectedArtImageArr;
    NSMutableArray *_selectedHandWritingArr;
    NSMutableArray *_selectedArtImageIdArr;   //存放艺术成就照片id
    NSMutableArray *_selectedHandWritingIdArr;//存放书法代表作id
    NSInteger _selectedIndex;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn1;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIButton *addBtn2;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation ApplyMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"申请成为书法名家";
    [self setNavBackBtnWithType:1];
    _selectedArtImageArr=[[NSMutableArray alloc]init];
    _selectedHandWritingArr=[[NSMutableArray alloc]init];
    
    _selectedArtImageIdArr=[[NSMutableArray alloc]init];
    _selectedHandWritingIdArr=[[NSMutableArray alloc]init];
}
- (void)createImageView
{
    NSArray *imageArr;
    UIView *bgView;
    UIButton *addBtn;
//    NSInteger index;
    if(_selectedIndex==0){
        imageArr=_selectedArtImageArr;
        bgView=_bgView1;
        addBtn=_addBtn1;
//        index=100;
    }else{
        imageArr=_selectedHandWritingArr;
        bgView=_bgView2;
        addBtn=_addBtn2;
//        index=200;
    }
    for(UIView *subView in bgView.subviews){
        if(subView.tag!=50){
            [subView removeFromSuperview];
        }
    }
//    [bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<imageArr.count;i++){
        UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame=CGRectMake(30+i*(60+10), 15, 60, 60);
        imageBtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageBtn.imageView.clipsToBounds=YES;
        [imageBtn setImage:imageArr[i] forState:UIControlStateNormal];
        imageBtn.tag=100+i;
        [bgView addSubview:imageBtn];
        
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(imageArr.count==3){
        addBtn.hidden=YES;
    }else{
        addBtn.hidden=NO;
        addBtn.frame=CGRectMake(30+(60+10)*imageArr.count, 15, 60, 60);
    }
}
//TODO:点击图片
- (void)imageBtnClick:(UIButton *)button
{
    
    __weak typeof(self) weakSelf=self;
    PhotoManagerViewController *pmvc=[[PhotoManagerViewController alloc]initWithNibName:@"PhotoManagerViewController" bundle:nil];
    pmvc.image=[button imageForState:UIControlStateNormal];
    [pmvc setDeletePhoto:^(UIImage *image) {
        if([_selectedArtImageArr containsObject:image]){
            _selectedIndex=0;
            [_selectedArtImageIdArr removeObjectAtIndex:[_selectedArtImageArr indexOfObject:image]];
            [_selectedArtImageArr removeObject:image];
            [weakSelf createImageView];
        }else{
            _selectedIndex=1;
            [_selectedHandWritingIdArr removeObjectAtIndex:[_selectedHandWritingArr indexOfObject:image]];
            [_selectedHandWritingArr removeObject:image];
            [weakSelf createImageView];
        }
    }];
    [self.navigationController pushViewController:pmvc animated:YES];
}
- (IBAction)sumbmitBtnClick:(id)sender {
    if(_textView.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请简略描述你的成就"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_textView.text]){
        [SVProgressHUD showErrorWithStatus:@"简略描述不能全为空格"];
        return;
    }
    if(_selectedArtImageArr.count==0){
        [SVProgressHUD showErrorWithStatus:@"请上传您的艺术成就照片"];
        return;
    }
    if(_selectedHandWritingArr.count==0){
        [SVProgressHUD showErrorWithStatus:@"请上传您的书法代表作"];
        return;
    }
    [SVProgressHUD show];
    _submitBtn.userInteractionEnabled=NO;
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ApplySenior" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:_textView.text forKey:@"Content"];
    [parameterDic setValue:[_selectedHandWritingIdArr componentsJoinedByString:@","] forKey:@"AchievementPic"];
    [parameterDic setValue:[_selectedArtImageIdArr componentsJoinedByString:@","] forKey:@"PerWorksPic"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _submitBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            personalModel.UserType=@"2";
            personalModel.ApplyState=@"0";
            
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:personalModel.UserType forKey:@"UserType"];
            [infoDic setValue:personalModel.ApplyState forKey:@"ApplyState"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    } failure:^(NSError *error){
        _submitBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
- (IBAction)addArtBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    _selectedIndex=0;
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}
- (IBAction)addCalligraphyBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    _selectedIndex=1;
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
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
    [self uploadHeaderImageView:image];
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
- (void)uploadHeaderImageView:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 0.6);
    
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
            
            if(_selectedIndex==0){
                [_selectedArtImageArr addObject:[UIImage imageWithData:data]];
                [_selectedArtImageIdArr addObject:responseObject[@"data"][@"ID"]];
            }else{
                [_selectedHandWritingArr addObject:[UIImage imageWithData:data]];
                [_selectedHandWritingIdArr addObject:responseObject[@"data"][@"ID"]];
            }
            [self createImageView];
        }
    } FailBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadFail:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
    }];
}

#pragma mark textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>0){
        self.placeHolderLabel.hidden=YES;
        
    }else{
        self.placeHolderLabel.hidden=NO;
        
    }
}
//TODO:处理光标上下跳动
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
        CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
        if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
            textView.contentOffset = CGPointMake(0, caretY);
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@""];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
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
