//
//  UIView+Find.m
//  PickPhotosDemo
//
//  Created by twb on 2025/9/19.
//

#import "UIView+Find.h"

@implementation UIView (Find)

- (UIView *)mars_findSubviewOfClass:(NSString *)viewClass {
    for (UIView *subview in self.subviews) {
#if DEBUG
        NSLog(@">>>>>>>>>>>>>>>>>>>>Found: %@", NSStringFromClass(subview.class));
#endif
        if ([NSStringFromClass(subview.class) hasSuffix:viewClass]) {
            return subview;
        } else {
            UIView *found = [subview mars_findSubviewOfClass:viewClass];
            if (found) {
                return found;
            }
        }
    }
    return nil;
}

@end
