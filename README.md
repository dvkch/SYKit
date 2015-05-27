SYKit
=======


Some useful categories and other classes on UIKit and Foundation


####UIDevice+SYCategories

Obtain an enum value representing the current device model:

	+ (UIDeviceModel)deviceModelFromHardwareString:(NSString *)value;
	+ (UIDeviceModel)deviceModelFromModelNumber:(NSString *)value;
	- (UIDeviceModel)deviceModel;
	- (BOOL)isIpad;

	// UIDeviceModeliPhone5C
	[UIDevice deviceModelFromHardwareString:@"iPhone5,4"]


Help you identifying if the current device supports well blurring views. For now this isn't customizable. I used reports found on the web of people using `FXBlurView` but feel free to send a push request if you want to remove or add a model. The iOS version is not used, only the device model. Models where blurring is too slow for use:

	UIDeviceModeliPodTouch1G
	UIDeviceModeliPodTouch2G
	UIDeviceModeliPodTouch3G
	UIDeviceModeliPodTouch4G
	
	UIDeviceModeliPhone
	UIDeviceModeliPhone3G
	UIDeviceModeliPhone3GS
	UIDeviceModeliPhone4
	UIDeviceModeliPhone4S
	
	UIDeviceModeliPad1
	UIDeviceModeliPad3
 
	- (BOOL)shouldSupportViewBlur;


Methods to access and use the iOS version string:

	- (NSString*)systemVersionCached;

	- (BOOL)iOSisEqualTo:(NSString *)version;
	- (BOOL)iOSisGreaterThan:(NSString *)version;
	- (BOOL)iOSisGreaterThanOrEqualTo:(NSString *)version;
	- (BOOL)iOSisLessThan:(NSString *)version;
	
	+ (BOOL)iOSis6Plus;
	+ (BOOL)iOSis7Plus;
	+ (BOOL)iOSis8Plus;

####UIScreen+SYCategories

In iOS8 Apple changed the behavior of `-[UIScreen bounds]` method. It used to return the size of the screen independently of the interface orientation, but this is no longer the case. The following method restores this behavior:

	- (CGRect)boundsFixedToPortraitOrientation;

If like me you still support old iOS versions and therefore don't use auto-layout this method allows you to obtain the usable scree, size as a frame with some options:

	- (CGRect)screenRectForOrientation:(UIInterfaceOrientation)orientation
    	showStatusBarOnIphoneLandscape:(BOOL)showStatusBarOnIphoneLandscape
        	   ignoreStatusBariOSOver7:(BOOL)ignoreStatusBariOSOver7;


####SYScreenHelper

Wrapper around `UIScreen (SYCategories)` methods to create frames representing the full screen or usable screen space (uses y offset to ignore iOS7+ statys bar). 

It uses a gcd-based singleton to keep a shared instance. A single property can be changed: `BOOL showStatusBarOnIphoneLandscape`. It controls whether or not the iOS status bar will be hidden or not on an iPhone in landscape.

Methods:

	- (void)updateStatusBarVisibility:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
	- (CGRect)screenRect:(UIInterfaceOrientation)orientation; // has offset (origin.y != 0) on iOS >= 7
	- (CGRect)fullScreenRect:(UIInterfaceOrientation)orientation; // ignores status bar

####CGTools

Contains C functions to work with `CGRect`s

	CGRect CGRectCenteredInsideRectWithSize(CGRect inside, CGSize size, BOOL fromOutside);
	CGRect CGRectCenteredSquarreInsideRectWithSize(CGRect inside, CGFloat size, BOOL fromOutside);
	CGRect CGRectInsetPercent(CGRect rect, CGFloat percentX, CGFloat percentY);


License
===

Use it as you like in every project you want, redistribute with mentions of my name and don't blame me if it breaks :)

-- dvkch
 