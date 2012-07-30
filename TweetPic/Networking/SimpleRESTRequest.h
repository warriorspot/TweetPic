
#import <Foundation/Foundation.h>

/// SimpleRESTRequest implements a bare-bone JSON-based REST request interface.
/// It is best used for RESTful services that present their interface via
/// a "base URL"/"specific URL" format (for example, a Rails based service).
/// It posts notifcations to the default notification center for success and
/// failure.  A successful request returns the JSON in the userInfo dictionary
/// via the SimpleRESTRequestJSONKey.  A failed request returns an NSError instance
/// via the SimpleRESTRequestFailureKey.
///
/// Notifications
///
/// registers for:
///
/// none
///
/// sends:
///
/// SimpleRESTRequestDidSucceedNotification
/// SimpleRESTReqeustDidFailNotification
///
/// Delegation
///
/// implements:
///
/// NSURLConnectionDelegate
///
/// delegates:
///
/// none

@interface SimpleRESTRequest: NSObject <NSURLConnectionDelegate>
{
@private
    /// The NSURLConnection used to make the request.
	NSURLConnection *_connection;
    
    /// The data returned by the NSURLConnection.
	NSMutableData *_data;
}

/// The base URL of the RESTful service
@property (nonatomic, strong) NSString * baseURL;

/// The target (i.e. specific) URL of the RESTful service
@property (nonatomic, strong) NSString * targetURL;

/// YES if the NSURLConnection is active, NO otherwise
@property (readonly) BOOL running;

/// Calls the designated initializer with nil for targetURL
///
/// @param baseURL
///     the base URL of the service
///
- (id) initWithBaseURL: (NSString *) baseURL;

/// Designated Intializer. Returns a SimpleRESTRequest instance.
///
/// @param baseURL
///     the base URL of the service
///
/// @param targetURL
///     the specific URL of the service
///
- (id) initWithBaseURL: (NSString *) baseURL
             targetURL: (NSString *) targetURL;

/// The base URL of the service (i.e. www.example.com/service)
- (NSString *) baseURL;

/// The specific URL within the base URL (i.e. food/eggs.json)
- (NSString *) targetURL;

/// Setter for baseURL
- (void) setBaseURL: (NSString *) baseURL;

/// Setter for targetURL
- (void) setTargetURL: (NSString *) targetURL;

/// Start the NSURLConnection
- (void) start;

/// Stop the NSURLConnection
- (void) stop;

@end

// Notifications

/// Posted when a request succeeds.  The userInfo dictionary contains
/// the JSON response from the service
extern NSString * const SimpleRESTRequestDidSucceedNotification;

/// The key to access the JSON respons for a successful request.
extern NSString * const SimpleRESTRequestJSONKey;

/// Posted when a request fails.  The userInfo dictionary contains an NSError
/// instance indicating the reason for failure.
extern NSString * const SimpleRESTRequestDidFailNotification;

/// The key to access the NSError instance sent when a request fails.
extern NSString * const SimpleRESTRequestFailureKey;
