
#import <Foundation/Foundation.h>
#import "Request.h"

@class TweetRequest;

/// TweetPicManager is responsible for creating TweetPic instances
/// based on a keyword used to search Twitter for matching tweets.
/// The keyword is received via a DidEnterSearchTermNotification.
/// When a search term is received, Twitter is queried via a TWRequest.
/// For each tweet found, a FetchMovieImageOperation is created
/// and added to an NSOperationQueue. For each operation that
/// completes, the resulting movie image is paired with the originating
/// tweet text in the form of a new TweetPic instance.  A TweetPicCreatedNotification
/// is then sent.  When the NSOperationQueue is empty, a TweetPicsCreatedNotification is
/// sent.  If an error occurs when attempting to query Twitter, or no tweets
/// are found for the given search term, a TweetPicErrorNotification is sent.
///
/// Each "session" of creating and responding to FetchMovieOperations is
/// wrapped in a begin/endBackgroundTask call.  This allows the fetching
/// of movie images to continue when the app is backgrounded.
///
/// Notifications
/// 
/// registers for:
/// 
/// DidEnterSearchTermNotification
/// 
/// sends:
/// 
/// TweetPicCreatedNotification
/// TweetPicsCreatedNotification
/// TweetPicErrorNotification
/// 
/// Delegation
/// 
/// implements:
/// 
/// RequestDelegate
/// 
/// delegates:
/// 
/// none

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