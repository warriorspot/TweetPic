
#import <Foundation/Foundation.h>
#import "Request.h"

@class TweetRequest;

@interface TweetPicManager : NSObject <RequestDelegate>

@end

/// Notification posted when a TweetPic created. The TweetPic
//  is sent in the notifications userInfo property
extern NSString * const TweetPicCreatedNotification;

/// The key to access the TweetPic in a TweetPicCreatedNotification
extern NSString * const TweetPicKey;

/// Notification sent when all TweetPics for a given search term
/// have been created.
extern NSString * const TweetPicsCreatedNotification;

/// Notification sent when no TweetPics can be created for
/// a given search term.  A localized text description of the error
/// is sent in the userInfo property of the notification.
extern NSString * const TweetPicErrorNotification;

/// The key used to access the localized error description for
/// a TweetPicErrorNotification userInfo dictionary.
extern NSString * const TweetPicErrorDescriptionKey;