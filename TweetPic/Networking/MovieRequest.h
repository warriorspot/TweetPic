
#import <Foundation/Foundation.h>
#import "Request.h"

/// MovieRequest encapsulates an HTTP request to the
/// RottenTomatoes API.   It allows the API to be search for
/// movies by keyword.
///
/// A MovieRequest returns a Movie instance via the
/// request:didSucceedWithObject: RequestDelegate method.
///
/// To request a movie, create an instance, set a delegate, and invoke the
/// startWithSearchTerm: method.
///
/// Notifications
///
/// registers for:
///
/// SimpleRESTRequestDidSucceedNotification
/// SimpleRESTRequestDidFailNotification
///
/// sends:
///
/// none
///
/// Delegation
///
/// implements:
///
/// none
///
/// delegates:
///
/// RequestDelegate
///
@interface MovieRequest : Request

@end
