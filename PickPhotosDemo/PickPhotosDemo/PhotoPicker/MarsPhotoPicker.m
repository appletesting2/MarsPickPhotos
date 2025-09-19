//
//  MarsPhotoPicker.m
//  MarsPhoto
//
//  Created by twb on 15/9/3.
//  Copyright (c) 2025年 Twb. All rights reserved.
//

#import "MarsPhotoPicker.h"
#import "UIViewController+Hierarchy.h"
#import "UIView+Find.h"

@interface _MarsPhotoPicker : UIImagePickerController

@end

@implementation _MarsPhotoPicker

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

@end

@interface MarsPhotoPicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) _MarsPhotoPicker *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage, MarsPhotoPickerStatus status);

@end

@implementation MarsPhotoPicker

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popImagePickerNotification) name:@"kCCPopImagePickerNotification" object:nil];
}

- (void)__unregistNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)popImagePickerNotification {
    if (_imagePickerController != nil) {
        [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
        _imagePickerController = nil;
    }
    
    UIViewController *curVC = [UIViewController topVC];
    [curVC.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *, MarsPhotoPickerStatus status))completion {
    
    self.completion = completion;
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if (![self isPhotoLibraryAvailable]) {
            [self completionImagePick:self.imagePickerController image:nil status:MarsPhotoPickerNoPhoto];
            return;
        }
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![self isCameraAvailable]) {
            [self completionImagePick:self.imagePickerController image:nil status:MarsPhotoPickerNoCamera];
            return;
        }
    }
    
    if (!self.imagePickerController) {
        self.imagePickerController = [[_MarsPhotoPicker alloc] init];
        self.imagePickerController.delegate = self;
        
    }
    
    self.imagePickerController.allowsEditing = self.allowsEditing;
    self.imagePickerController.sourceType = sourceType;
    self.imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:70.0f/255.0f green:77.0f/255.0f blue:92.0f/255.0f alpha:1.0f];

    UIViewController *curVC = [UIViewController topVC];
    [curVC presentViewController:self.imagePickerController animated:YES completion:^{
        /// 解决Xcode16.x下编译出App，在iOS26下拍照按钮无法点击的问题。
        UIView *shutterView = [self.imagePickerController.view mars_findSubviewOfClass:@"CAMLiquidShutterView"];
        shutterView.userInteractionEnabled = YES;
    }];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma mark -

- (void)completionImagePick:(UIImagePickerController *)picker image:(UIImage *)image status:(MarsPhotoPickerStatus) status {
    if (picker) {
        [picker dismissViewControllerAnimated:YES
                                   completion:^{
                                       if (self.completion) {
                                           self.completion(image, status);
                                       }
                                   }];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [self completionImagePick:picker image:image status:MarsPhotoPickerNone];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self completionImagePick:picker image:nil status:MarsPhotoPickerNone];
}

@end
