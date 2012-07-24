
#import <Foundation/Foundation.h>

@interface SimpleRESTRequest: NSObject <NSURLConnectionDelegate>
{
@private
	NSURLConnection *_connection;
	NSMutableData *_data;
}

@property (nonatomic, strong) NSString * baseURL;
@property (nonatomic, strong) NSString * targetURL;
@property (readonly) BOOL running;

- (id) initWithBaseURL: (NSString *) baseURL;
- (id) initWithBaseURL: (NSString *) baseURL 
             targetURL: (NSString *) targetURL;

- (NSString *) baseURL;
- (NSString *) targetURL;

- (void) setBaseURL: (NSString *) baseURL;
- (void) setTargetURL: (NSString *) targetURL;


- (void) start;
- (void) stop;

@end

// Notifications

extern NSString * const SimpleRESTRequestDidSucceedNotification;
extern NSString * const SimpleRESTRequestJSONKey;
extern NSString * const SimpleRESTRequestDidFailNotification;
extern NSString * const SimpleRESTRequestFailureKey;