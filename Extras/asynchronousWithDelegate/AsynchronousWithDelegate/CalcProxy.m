/**
 * Copyright 2015 Tim Lindquist,
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p/>
 * Purpose: A sample Objective-C iOS app to demonstrate asynchronous NSURLConnections
 *
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
 * @version March 29, 2015
 */

#import "CalcProxy.h"

static int iden = 1;

@interface CalcProxy()

@property (unsafe_unretained, atomic) SEL action;
@property (strong, atomic) id target;
@property (strong, atomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSString * urlString;

@end

@implementation CalcProxy

- (id) initWithTarget: (id) target action: (SEL) action{
    if( self = [super init] ){
        self.target = target;
        self.action = action;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Server_URL" ofType:@"plist"];
        NSDictionary * serverDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.urlString = [serverDictionary objectForKey:@"server_url"];
        //NSLog(@"server url in plist is: %@",[serverDictionary objectForKey:@"server_url"]);
    }
    return self;
}

- (BOOL) add: (double) left to: (double) right {
    BOOL ret = NO;
    NSArray * parms = @[[NSNumber numberWithDouble:left], [NSNumber numberWithDouble:right]];
    if ([self dispatchCall: @"add" withParms: parms]) {
        ret = YES;
    }
    return ret;
}

- (BOOL) subtract: (double) left by: (double) right{
    BOOL ret = NO;
    NSArray * parms = @[[NSNumber numberWithDouble:left], [NSNumber numberWithDouble:right]];
    if ([self dispatchCall: @"subtract" withParms: parms]) {
        ret = YES;
    }
    return ret;
}

- (BOOL) multiply: (double) left times: (double) right{
    BOOL ret = NO;
    NSArray * parms = @[[NSNumber numberWithDouble:left], [NSNumber numberWithDouble:right]];
    if ([self dispatchCall: @"multiply" withParms: parms]) {
        ret = YES;
    }
    return ret;
}

- (BOOL) divide: (double) left by: (double) right{
    BOOL ret = NO;
    NSArray * parms = @[[NSNumber numberWithDouble:left], [NSNumber numberWithDouble:right]];
    if ([self dispatchCall: @"divide" withParms: parms]) {
        ret = YES;
    }
    return ret;
}

// called by the math methods to package call, convert to json, and send request to server.
- (BOOL) dispatchCall: (NSString*) method withParms: (NSArray*) parms{
    BOOL ret = NO;
    NSNumber * ID = [NSNumber numberWithInt:iden++];
    NSDictionary * rpcDict = @{@"jsonrpc":@"2.0",  @"method":method, @"params":parms, @"id":ID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rpcDict
                                                       //options:NSJSONWritingPrettyPrinted
                                                       options:0
                                                         error:&error];
    NSLog(@"jsonData: %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    self.receivedData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if(request){
        request.URL = url;
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        request.HTTPBody= jsonData;
        ret = YES;
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
    return ret;
}

// NSURLConnectionDelegate and NSURLConnectionDataDelegate methods.

// May be called multiple times, such as a redirect, so reset the data.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"connection: didReceiveResponse");
}

//   Append the new data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"connection: didReceiveData:");
    if(data){
        //NSLog(@"in didReceiveData and got %lu bytes: ",(unsigned long)data.length);
        [self.receivedData appendData:data];
    }else{
        NSLog(@"in didReceiveData, but data is nil");
    }
}

// Connection has completed. De-serialize to nsdictionary and pick out result value.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSError *error;
    NSDictionary *myDictionary = @{@"result":@"no return value"};
    if(self.receivedData==nil){
        NSLog(@"connectionDidFinishLoading with No data received");
    } else {
        NSLog(@"receivedData: %@",[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
        myDictionary = [NSJSONSerialization
                                      JSONObjectWithData:self.receivedData
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
    }
    id result = [myDictionary objectForKey:@"result"];
    double res = 0;
    if([result class]==[@2.2 class]){
        res = [[myDictionary objectForKey:@"result"] doubleValue];
    }
    //call the method in the controller who will perform the ui update.
    [self.target performSelector:self.action withObject:[NSNumber numberWithDouble:res]];
    connection = nil;
    self.receivedData = nil;
}

@end
