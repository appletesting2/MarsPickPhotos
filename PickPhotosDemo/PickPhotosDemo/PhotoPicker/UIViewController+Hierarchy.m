//
//  UIViewController+Hierarchy.m
//  PickPhotosDemo
//
//  Created by twb on 2025/9/19.
//

#import "UIViewController+Hierarchy.h"

UIWindow *CCIGetKeyWindow(void) {
    NSArray<UIScene *> *allScenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
    if (allScenes.count > 0) {
        UIWindowScene *curWinScene = (UIWindowScene *)(allScenes[0]);
        if ([curWinScene.delegate isKindOfClass:NSClassFromString(@"SceneDelegate")]) {
            return [curWinScene.delegate performSelector:@selector(window)];
        }
    }
    return nil;
}

@implementation UIViewController (Hierarchy)

+ (UIViewController *)topVC {
    UIViewController *curVC = CCIGetKeyWindow().rootViewController;
    UIViewController *topVC = nil;

    while (curVC) {
        if ([curVC isKindOfClass:[UINavigationController class]]) {
            UIViewController *tmpVC = [(UINavigationController *)curVC topViewController];
            topVC = tmpVC.presentedViewController ? tmpVC.presentedViewController : tmpVC;
            curVC = tmpVC.presentedViewController;

            if ([curVC isKindOfClass:[UINavigationController class]]){
                topVC = curVC.presentedViewController ? curVC.presentedViewController : curVC;
                curVC = curVC.presentedViewController;
            }
        }else {
            topVC = curVC.presentedViewController ? curVC.presentedViewController : curVC;
            curVC = curVC.presentedViewController;
        }
    }
    return topVC;
}

@end
