#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.testflight..OOTD-Swift";

/// The "UIpurple" asset catalog color resource.
static NSString * const ACColorNameUIpurple AC_SWIFT_PRIVATE = @"UIpurple";

/// The "settingsBackground" asset catalog color resource.
static NSString * const ACColorNameSettingsBackground AC_SWIFT_PRIVATE = @"settingsBackground";

/// The "icons8-google-180" asset catalog image resource.
static NSString * const ACImageNameIcons8Google180 AC_SWIFT_PRIVATE = @"icons8-google-180";

#undef AC_SWIFT_PRIVATE