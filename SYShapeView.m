//
//  SYShapeView.m
//  SYKit
//
//  Created by Stan Chevallier on 09/02/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import "SYShapeView.h"

@implementation SYShapeView

@dynamic layer;

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.layoutSubviewsBlock)
        self.layoutSubviewsBlock(self);
}

@end
