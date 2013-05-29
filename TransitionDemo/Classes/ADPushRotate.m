//
//  ADPushRotate.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 29/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ADPushRotate.h"

@implementation ADPushRotate

- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect {
    self = [super initWithType:ADTransitionTypePush];
    if (self != nil) {
        const CGFloat viewWidth = sourceRect.size.width;
        const CGFloat viewHeight = sourceRect.size.height;
        const CGFloat angle = M_PI / 2.0f;
        
        CABasicAnimation * inSwipeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        inSwipeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        
        CGPoint anchorPoint;
        CATransform3D startTranslation;
        CATransform3D rotation;
        switch (orientation) {
            case ADTransitionRightToLeft:
            {
                inSwipeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(viewWidth, 0.0f, 0.0f)];
                anchorPoint = CGPointMake(0, 0.5f);
                startTranslation = CATransform3DMakeTranslation(-viewWidth * 0.5f, 0, 0);
                rotation = CATransform3DRotate(startTranslation, angle, 0, 1.0f, 0);
            }
                break;
            case ADTransitionLeftToRight:
            {
                inSwipeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-viewWidth, 0.0f, 0.0f)];
                anchorPoint = CGPointMake(1.0f, 0.5f);
                startTranslation = CATransform3DMakeTranslation(viewWidth * 0.5f, 0, 0);
                rotation = CATransform3DRotate(startTranslation, -angle, 0, 1.0f, 0);
            }
                break;
            case ADTransitionTopToBottom:
            {
                inSwipeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0f, -viewHeight, 0.0f)];
                anchorPoint = CGPointMake(0.5f, 1.0f);
                startTranslation = CATransform3DMakeTranslation(0, viewHeight * 0.5f, 0);
                rotation = CATransform3DRotate(startTranslation, angle, 1.0f, 0, 0);
            }
                break;
            case ADTransitionBottomToTop:
            {
                inSwipeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0f, viewHeight, 0.0f)];
                anchorPoint = CGPointMake(0.5f, 0);
                startTranslation = CATransform3DMakeTranslation(0, -viewHeight * 0.5f, 0);
                rotation = CATransform3DRotate(startTranslation, -angle, 1.0f, 0, 0);
            }
                break;
            default:
                NSAssert(FALSE, @"Unhandled ADTransitionOrientation");
                break;
        }
        
        
        CABasicAnimation * outAnchorPointAnimation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
        outAnchorPointAnimation.fromValue = [NSValue valueWithCGPoint:anchorPoint];
        outAnchorPointAnimation.toValue = [NSValue valueWithCGPoint:anchorPoint];
        
        CABasicAnimation * outRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        outRotationAnimation.fromValue = [NSValue valueWithCATransform3D:startTranslation];
        outRotationAnimation.toValue = [NSValue valueWithCATransform3D:rotation];
        
        CABasicAnimation * outOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        outOpacityAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        outOpacityAnimation.toValue = [NSNumber numberWithFloat:0.0f];
        
        CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
        [outAnimation setAnimations:@[outOpacityAnimation, outRotationAnimation, outAnchorPointAnimation]];
        
        _inAnimation = inSwipeAnimation;
        _outAnimation = outAnimation;
        _inAnimation.duration = duration;
        _outAnimation.duration = duration;
        [_inAnimation retain];
        [_outAnimation retain];
        [self finishInit];
    }
    return self;
}

@end
