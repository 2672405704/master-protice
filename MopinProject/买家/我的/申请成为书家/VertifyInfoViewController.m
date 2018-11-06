//
//  VertifyInfoViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "VertifyInfoViewController.h"
#import "CompleteAccountViewController.h"
#import "Utility.h"
#import "ApplyModel.h"

@interface VertifyInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    NSString *_selectedImageId1;
    NSString *_selectedImageId2;
    NSInteger _selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@end

@implementation VertifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"验证我的身份信息";
    [self setNavBackBtnWithType:1];
    
    [self resetView];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//TODO:设置View
- (void)resetView
{
    _bgScrollView.backgroundColor=self.view.backgroundColor;
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, 202);
    
    _imageView1.contentMode=UIViewContentModeScaleAspectFill;
    _imageView1.clipsToBounds=YES;
    
    _imageView2.contentMode=UIViewContentModeScaleAspectFill;
    _imageView2.clipsToBounds=YES;

    _bgView1.layer.cornerRadius=4;
    _bgView1.layer.masksToBounds=YES;
    
    _bgView2.layer.cornerRadius=4;
    _bgView2.layer.masksToBounds=YES;
    
    _bgView3.layer.cornerRadius=4;
    _bgView3.layer.masksToBounds=YES;
}
- (IBAction)confirmBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    if(![self isIdentityCard:_textField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号码"];
        return;
    }
    if(_selectedImageId1.length==0){
        [SVProgressHUD showErrorWithStatus:@"请上传身份证正面照片"];
        return;
    }
    if(_selectedImageId2.length==0){
        [SVProgressHUD showErrorWithStatus:@"请上传身份证背面照片"];
        return;
    }
    _applyModel.IDCard=_textField.text;
    _applyModel.IDCardPic=[NSString stringWithFormat:@"%@,%@",_selectedImageId1,_selectedImageId2];
    
    CompleteAccountViewController *cavc=[[CompleteAccountViewController alloc]initWithNibName:@"CompleteAccountViewController" bundle:nil];
    cavc.applyModel=_applyModel;
    [self.navigationController pushViewController:cavc animated:YES];
}
- (IBAction)cameraBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    UIButton *btn=(UIButton *)sender;
    _selectedIndex=btn.tag-100;
    //选择相机相册
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
}
#pragma mark - scorllView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
    //赋值
    //    NSData *data= UIImagePNGRepresentation(image);
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
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    
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
                if(GETVIEWHEIGHT(_imageView1)==0){
                    CGRect frame=_imageView1.frame;
                    frame.size.height=(kkDeviceWidth-60)*0.65;
                    _imageView1.frame=frame;
                    
                    frame=_bgView3.frame;
                    frame.origin.y=CGRectGetMaxY(_imageView1.frame)+10;
                    _bgView3.frame=frame;
                    
                    frame=_imageView2.frame;
                    frame.origin.y=CGRectGetMaxY(_bgView3.frame)+10;
                    _imageView2.frame=frame;
                    
                    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_imageView2.frame)+10);
                }
                _imageView1.image=image;
                _selectedImageId1=responseObject[@"data"][@"ID"];
            }else{
                if(GETVIEWHEIGHT(_imageView2)==0){
                    CGRect frame=_imageView2.frame;
                    frame.size.height=(kkDeviceWidth-60)*0.65;
                    _imageView2.frame=frame;
                    
                    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_imageView2.frame)+10);
                }
                _imageView2.image=image;
                _selectedImageId2=responseObject[@"data"][@"ID"];
            }
        }
    } FailBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadFail:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
    }];
}
- (BOOL)isIdentityCard:(NSString *)IDCardNum
{
    NSString * regex =  @"^(\\d{15}|\\d{17}[\\dxX])$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL iscard = [pred evaluateWithObject:IDCardNum];
    return iscard;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
