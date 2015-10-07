//
//  SYSearchField.m
//  SYKit
//
//  Created by Stanislas Chevallier on 03/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "SYSearchField.h"
#import "UIImage+SYKit.h"

@interface SYSearchField () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSString *lastText;
@property (nonatomic, assign) BOOL isTyping;
@end

@implementation SYSearchField

- (instancetype)init
{
    self = [super init];
    if (self) [self customInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self customInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self customInit];
    return self;
}

- (void)customInit
{
    if (self.textField)
        return;
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SYSearchField" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    // in case we're not using cocoapods
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    NSString *loupePath = [bundle pathForResource:@"loupe" ofType:@"png"];
    UIImage *loupeImg = [[UIImage imageWithContentsOfFile:loupePath] imageResizedSquarreTo:15];
    
    loupeImg = [loupeImg imageByAddingPaddingTop:0 left:0 right:10 bottom:2];
    loupeImg = [loupeImg imageMaskedWithColor:[UIColor lightGrayColor]];
    
    self.imageViewIcon = [[UIImageView alloc] initWithImage:loupeImg];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setColor:[UIColor darkGrayColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    CGRect f = self.activityIndicatorView.frame; f.size.width += 10;
    [self.activityIndicatorView setFrame:f];
    
    self.textField = [[UITextField alloc] init];
    [self.textField setTextAlignment:NSTextAlignmentLeft];
    [self.textField setDelegate:self];
    [self.textField setBorderStyle:UITextBorderStyleNone];
    [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textField setReturnKeyType:UIReturnKeyGo];
    [self.textField setKeyboardType:UIKeyboardTypeURL];
    [self.textField setPlaceholder:@"Search or open a website"];
    [self.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textField setLeftView:self.imageViewIcon];
    [self.textField setLeftViewMode:UITextFieldViewModeUnlessEditing];
    [self addSubview:self.textField];
    
    [self setBackgroundColor:[UIColor colorWithWhite:222./255. alpha:1.]];
    [self.layer setCornerRadius:4.];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.tapGesture];
    
    [self setIsTyping:NO];
}

- (void)showLoadingIndicator:(BOOL)showLoadingIndicator
{
    if(showLoadingIndicator)
        [self.activityIndicatorView startAnimating];
    else
        [self.activityIndicatorView stopAnimating];
}

- (void)setIsTyping:(BOOL)isTyping animated:(BOOL)animated
{
    if(!animated)
    {
        [self setIsTyping:isTyping];
        return;
    }
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [self setIsTyping:isTyping];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(isTyping)
            [self.textField selectAll:nil];
    }];
}

- (void)setIsTyping:(BOOL)isTyping
{
    self->_isTyping = isTyping;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.isTyping)
    {
        [self.textField setLeftView:self.imageViewIcon];
        [self.textField setText:[self.displayedURL absoluteString]];
        [self.textField setFrame:CGRectInset(self.bounds, 10, 0)];
    }
    else
    {
        [self.textField setText:[self.displayedURL host]];
        [self.textField setLeftView:(self.textField.text.length == 0 ? self.imageViewIcon : self.activityIndicatorView)];
        
        NSString *str = self.textField.text.length ? self.textField.text : self.textField.placeholder;
        CGFloat w = [str sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
        w += self.imageViewIcon.image.size.width + 10;
        
        CGFloat maxWidth = CGRectGetWidth(self.bounds);
        w = MIN(maxWidth, w);
        [self.textField setFrame:CGRectMake(CGRectGetWidth(self.bounds) /2. - w/2., 0, w, CGRectGetHeight(self.bounds))];
    }
}

#pragma mark - Properties

- (void)setDisplayedURL:(NSURL *)displayedURL
{
    self->_displayedURL = displayedURL;
    [self setIsTyping:NO animated:NO];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    [self.textField setPlaceholder:placeholderText];
}

- (NSString *)placeholderText
{
    return self.textField.placeholder;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self setIsTyping:YES animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.lastText = textField.text;
    if(self.delegate)
        [self.delegate searchFieldDidReturn:self withText:textField.text];
    [self.textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self setIsTyping:NO animated:YES];
    return YES;
}

#pragma mark - UIGestureRecognizer

- (void)tapGestureTapped:(UITapGestureRecognizer *)sender
{
    [self.textField becomeFirstResponder];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

@end
