
#import "SimpleRESTRequest.h"

@implementation SimpleRESTRequest

@synthesize baseURL;
@synthesize targetURL;
@synthesize running;

- (id) init
{
	return [self initWithBaseURL: nil 
 	                   targetURL: nil];
    
}

- (id) initWithBaseURL: (NSString *) newBaseURL
{
	return [self initWithBaseURL: newBaseURL
 	                   targetURL: nil];
    
}

- (id) initWithBaseURL: (NSString *) newBaseURL 
             targetURL: (NSString *) newTargetURL 
{
	self = [super init];
    
	if(self)
	{
		self.baseURL = newBaseURL;
		self.targetURL = newTargetURL;
	}
    
	return self;
}

- (void) start
{
	if(self.running) return;
    
	running = YES;
    
	if(self.baseURL == nil && self.targetURL == nil)
	{
		NSLog(@"No URL defined for request");
		return;
	}
    
	NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL, self.targetURL];
	NSURL *url = [NSURL URLWithString: urlString];
    _connection = [NSURLConnection connectionWithRequest: [NSURLRequest requestWithURL: url] 
  											    delegate: self];	
	if(_connection)
 	{
        _data = [[NSMutableData alloc] init];
	    NSLog(@"starting request %@", [url absoluteString]);
	    [_connection start];
	}
}

- (void) stop
{
	running = NO;
	[_connection cancel];
}

#pragma mark - NSURLRequest methods

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
	NSLog(@"finished");
    
	NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData: _data options: 0 error: &error];
    
	if(error)
	{
		NSLog(@"Error parsing JSON %@", [error localizedDescription]);
	}
	else
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject: json forKey: SimpleRESTRequestJSONKey];
		[[NSNotificationCenter defaultCenter] postNotificationName: SimpleRESTRequestDidSucceedNotification
                                                            object: self
                                                          userInfo: userInfo]; 
	}
}

- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data
{
	NSLog(@"did receive data");
	[_data appendData: data];
}

- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response 
{
	NSLog(@"response");
}

- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
	running = NO;
    
	NSLog(@"connection failed");
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: error forKey: SimpleRESTRequestFailureKey];
    [[NSNotificationCenter defaultCenter] postNotificationName: SimpleRESTRequestDidFailNotification
 												        object: self
											          userInfo: userInfo]; 
}

@end

NSString * const SimpleRESTRequestDidSucceedNotification = @"SimpleRESTRequestDidSucceed";
NSString * const SimpleRESTRequestJSONKey = @"SimpleRESTRequestJSONKey";
NSString * const SimpleRESTRequestDidFailNotification = @"SimpleRESTRequestDidFail";
NSString * const SimpleRESTRequestFailureKey = @"SimpleRESTRequestFailureKey";