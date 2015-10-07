//
//  SYSearchField.h
//  SYKit
//
//  Created by Stanislas Chevallier on 03/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYSearchField;

@protocol SYSearchFieldDelegate <NSObject>
- (void)searchFieldDidReturn:(SYSearchField *)searchField withText:(NSString *)text;
@end

@interface SYSearchField : UIView

@property (nonatomic, strong) NSURL *displayedURL;
@property (nonatomic, weak) IBOutlet id<SYSearchFieldDelegate> delegate;
@property (nonatomic) IBInspectable NSString *placeholderText;

- (void)showLoadingIndicator:(BOOL)showLoadingIndicator;

@end
