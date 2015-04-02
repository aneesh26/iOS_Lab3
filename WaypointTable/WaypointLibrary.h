/**
 * Copyright 2015 Aneesh Shastry,
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
 * Purpose: An iOS application to manipulate Waypoints using UItable
 *
 * @author Aneesh Shastry ashastry@asu.edu
 *         MS Computer Science, CIDSE, IAFSE, Arizona State University
 * @version March 30, 2015
 */


#import <Foundation/Foundation.h>
#import "Waypoint.h"

@interface WaypointLibrary : NSObject
- (void) addWaypoint:(Waypoint*) waypoint;
//This method takes a waypoint object as parameter and adds that object to the library collection.
- (BOOL) removeWaypointNamed: (NSString*) wpName;
//This method takes a parameter which is the string name of a waypoint. The named waypoint is to be removed from the library.
- (Waypoint*) getWaypointNamed: (NSString*) wpName;
//This method takes a parameter which is the string name of a waypoint. The named waypoint object is returned from this method.
- (NSArray*) getNames;
//This method returns an array which contains the names of all waypoints currently stored in the library.
@property(strong,nonatomic)NSMutableDictionary *wpDict;


@end