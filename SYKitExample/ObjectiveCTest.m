//
//  ObjectiveCTest.m
//  SYKitExample
//
//  Created by Stanislas Chevallier on 27/06/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

#import "ObjectiveCTest.h"
#import <SYKit/SYKit-Swift.h>

@implementation ObjectiveCTest

+ (UIImage *)testNoirFilter
{
    // make sure the filter works
    UIImage *image = [[UIImage alloc] sy_imageWithColor:UIColor.redColor];
    return [image sy_applyingGreyscaleFilter:UIImageGreyscaleFilterNoir];
}

+ (BOOL)testFindSubviewByType
{
    // make sure the type reasure for ObjC in the swift file works
    UIView *baseView = [[UIView alloc] init];
    UIView *deepestChild = baseView;
    for (NSUInteger i = 0; i < 10; ++i) {
        UIView *subview = [[UIView alloc] init];
        [deepestChild addSubview:subview];
        deepestChild = subview;
    }
    [deepestChild addSubview:[[UIImageView alloc] init]];
    
    UIView *foundUIImageView_base       = [baseView sy_findSubviewsOfClass:UIImageView.class recursive:NO].firstObject;
    UIView *foundUIImageView_recursive  = [baseView sy_findSubviewsOfClass:UIImageView.class recursive:YES].firstObject;
    return foundUIImageView_base == nil && foundUIImageView_recursive != nil;
}

+ (void)testObjCExclusivesBridgings
{
    // make sure those classes are available in ObjC. similar test in ViewController.swift to make sure they are not available in Swift
    SYDevice *device = [[SYDevice alloc] initWithModel:UIDevice.currentDevice.sy_modelEnum];
    NSLog(@"ObjC: %ld, %@", UIDevice.currentDevice.sy_modelEnum, device.hardwareStrings);
}

@end
