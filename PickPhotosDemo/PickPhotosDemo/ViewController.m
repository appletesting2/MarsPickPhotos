//
//  ViewController.m
//  PickPhotosDemo
//
//  Created by twb on 2025/9/19.
//

#import "ViewController.h"
#import "MarsPhotoPicker.h"

@interface ViewController ()

@property (nonatomic, strong) MarsPhotoPicker *photoPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoPicker = [[MarsPhotoPicker alloc] init];
    
}

- (IBAction)__didClickPickPhotos:(id)sender {
    [self.photoPicker pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage * _Nonnull image, MarsPhotoPickerStatus status) {
        if (status == MarsPhotoPickerNoCamera) {
            return;
        }
        
        if (image != nil) {
            NSLog(@">>>>>>>>>>>>>>>>>>>. 已经拍摄图片:%@", image);
        }
    }];
}

@end
