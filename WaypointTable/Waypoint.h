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
 * Purpose: A sample Objective-C command line program to manipulate waypoints using JSON RPC
 *
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
 * @version March 12, 2015
 */

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    Statute,
    Nautical,
    Kmeter
} Units;

#define radiusE 6371

@interface Waypoint : NSObject

//public properties of the waypoint include lat, lon, and name
@property (nonatomic) double lat;
@property (nonatomic) double lon;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * category;

// initialize a waypont object with values
- (id) initWithLat: (double) lat
               lon: (double) lon
              name: (NSString *) name
           address: (NSString *) address
          category: (NSString *) category;

// a string representation of the waypoint
- (NSString*) toString;

// great circle (an arc not a straight line) distance from this waypoint to lat, lon
- (double) distanceGCTo: (double) lat lon: (double) lon scale: (Units) scale;

// initial true heading for the great circle route. heading changes continuously.
- (double) bearingGCInitTo: (double) lat lon: (double) lon;


- (NSData *) toJson;

@end
