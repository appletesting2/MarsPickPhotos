//
//  CCIImagePickerController.m
//  MarsClass
//
//  Created by twb on 15/7/3.
//  Copyright (c) 2015年 Hujiang. All rights reserved.
//

#import "CCIImagePickerController.h"
#import "UIViewController+CCI.h"
#import "UIView+CCI.h"

@interface _CCImagePickerController : UIImagePickerController

@end

@implementation _CCImagePickerController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

@end


@interface CCIImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) _CCImagePickerController *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage, CCIImagePickerStatus status);

@end

@implementation CCIImagePickerController

- (id)init {
    self = [super init];
    if (self) {
        self.allowsEditing = YES;
        
        [self __registNotifications];
    }
    return self;
}

-(void)dealloc {
    [self __unregistNotifications];
}

#pragma mark - Notifications

- (void)__registNotifications {
    // 外问控制移除图片选择器窗口
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popImagePickerNotif) name:@"kCCPopImagePickerNotification" object:nil];
}

- (void)__unregistNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  帐号被踢
 */
- (void)popImagePickerNotif {
    if (_imagePickerController != nil) {
        [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
        _imagePickerController = nil;
    }
    
    UIViewController *curVC = [UIViewController topViewController];
    [curVC.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *, CCIImagePickerStatus status))completion{
    
    self.completion = completion;
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if (![self isPhotoLibraryAvailable]) {
            [self completionImagePick:self.imagePickerController image:nil status:CCIImagePickerStatusNotPhoto];
            return;
        }
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![self isCameraAvailable]) {
            [self completionImagePick:self.imagePickerController image:nil status:CCIImagePickerStatusNotCamera];
            return;
        }
    }
    
    if (!self.imagePickerController) {
        self.imagePickerController = [[_CCImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        
    }
    
    self.imagePickerController.allowsEditing = self.allowsEditing;
    self.imagePickerController.sourceType = sourceType;
    self.imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:70.0f/255.0f green:77.0f/255.0f blue:92.0f/255.0f alpha:1.0f];

    UIViewController *curVC = [UIViewController topViewController];
    [curVC presentViewController:self.imagePickerController animated:YES completion:^{
        UIView *shutterView = [self.imagePickerController.view cci_findSubviewOfClass:@"CAMLiquidShutterView"];
        shutterView.userInteractionEnabled = YES;
    }];
}

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma mark -

- (void)completionImagePick:(UIImagePickerController *)picker image:(UIImage *)image status:(CCIImagePickerStatus) status {
    if (picker) {
        [picker dismissViewControllerAnimated:YES
                                   completion:^{
                                       if (self.completion) {
                                           self.completion(image, status);
                                       }
                                   }];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [self completionImagePick:picker image:image status:CCIImagePickerStatusNone];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self completionImagePick:picker image:nil status:CCIImagePickerStatusNone];
}

@end
