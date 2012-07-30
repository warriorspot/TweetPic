
#import <Foundation/Foundation.h>

@protocol RequestDelegate;


/// Defines a bare-bones interface for a generic HTTP request based on
/// a keyword search.
/// Defines a simple delegate protocol for dealing with the
/// results of a request.
///
/// This class is intended for subclassing.  
///
@interface Request : NSObject

/// YES if the request is currently in-progress, NO otherwise.
@property (readonly) BOOL active;

/// The delegate of this request.  The delgate can optionally implement
/// the RequestDelegate protocol.
@property (nonatomic, assign) id delegate;

/// Starts the request given the supplied search term.
///
/// @param searchTerm
///     The text to search for.  The meaning of searchTerm is implementation
///     dependent.
- (void) startWithSearchTerm: (NSString *) searchTerm;

/// Stops the current in-progress request (if possible).
- (void) stop;

@end

/// Defines a simple protocol for delegates of subclasses of Request.
/// Notifies the delegate of the success or failure of the request.
///
@protocol RequestDelegate

@optional

/// Indicates a successful request.  The class of the instance returned
/// in the 'object' parameter is define by the subclass.
///
/// @param request
///     the Request that succeeded
///
/// @param object
///     an implementation-dependent instance of some object.  Often this
///     will an instance of an application specific model object populated
///     with data returned by the HTTP service.
///
- (void) request: (Request *) request didSucceedWithObject: (id) object;

/// Indicates a failed request.  If possible, a populated NSError object
/// is sent to the delgate.
///
/// @param request
///     the Request that failed
///
/// @param error
///     an NSError object that indicates the reason for failure
///
- (void) request: (Request *) request didFailWithError: (NSError *) error;

@end