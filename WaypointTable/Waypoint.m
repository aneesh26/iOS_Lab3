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
 * Purpose: A sample Objective-C command line program to manipulate waypoints
 *
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
 * @version March 12, 2015
 */

#import "Waypoint.h"

@implementation Waypoint

- initWithLat: (double) lat lon: (double) lon name: (NSString*) name address: (NSString*) address category: (NSString*) category{
    if ( (self = [super init]) ) {
        self.lat = lat;
        self.lon = lon;
        self.name = name;
        self.address = address;
        self.category = category;
    }
    return self;
}

- (NSString*) toString {
    return [NSString stringWithFormat:@"Waypoint name: %s, lat: %6.4f, lon: %6.4f",
            [self.name UTF8String], self.lat, self.lon];
}

- (double) distanceGCTo: (double) lat lon: (double) lon scale: (Units) scale{
    double ret = 0.0;
    double dlatRad = [self toRadians: (lat - self.lat)];
    double dlonRad = [self toRadians: (lon - self.lon)];
    double latOrgRad = [self toRadians: (self.lat)];
    double a = sin(dlatRad/2) * sin(dlatRad/2) +
    sin(dlonRad/2) * sin(dlonRad/2) * cos(latOrgRad) *
    cos([self toRadians: lat]);
    ret = radiusE * (2 * atan2(sqrt(a), sqrt(1 - a)));
    // ret is already in kilometers. switch to either Statute or Nautical?
    switch(scale) {
        case Statute:
            ret = ret * 0.62137119;
            break;
        case Nautical:
            ret = ret * 0.5399568;
            break;
    }
    return ret;
}

- (double) bearingGCInitTo: (double) lat lon: (double) lon {
    double ret = 0.0;
    double dlonRad = [self toRadians: (lon - self.lon)];
    double latOrgRad = [self toRadians: (self.lat)];
    double y = sin(dlonRad) * cos([self toRadians: lat]);
    double x = cos(latOrgRad)*sin([self toRadians:lat]) -
    sin(latOrgRad)*cos([self toRadians: lat])*
    cos(dlonRad);
    ret = [self toDegrees: atan2(y,x)];
    ret = fmod((ret+360.0),360.0);
    return ret;
}

- (double) toRadians: (double) angle {
    return angle * M_PI / 180.0;
}

- (double) toDegrees: (double) radians {
    return radians * (180.0 / M_PI);
}

@end
