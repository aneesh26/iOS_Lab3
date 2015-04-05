package ser423;

/**
 * Copyright (c) 2015 Tim Lindquist,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p/>
 * Purpose: This class is part of an example developed for the mobile
 * computing class at ASU Poly. The application provides a waypoint service.
 * This interface defines the operations that can be performed on the waypoint
 * library, and which are implemented and visible to clients via jsonrpc.
 *
 * @author Tim Lindquist
 * @version 2/8/2015
 **/
public interface WaypointLibrary {

   /**
    * Calling resetWaypoints causes the library to be re-initialized (remove all existing
    * waypoints and re-read the waypoints.json file to re-initialize the library to the
    * original waypoints.
    **/
   public void resetWaypoints();

   /**
    * Calling add causes an additional library entry to be created for the waypoint which
    * is the parameter. If the name field of the parameter matches an already existing
    * waypoint in the library, then that waypoint is replaced (modified) with the new
    * information. Note, the operation is a complete overright of the existing waypoint.
    * I.E., don't leave any fields null in the argument unless you want the libary to
    * store the null value.
    **/
   public void add(Waypoint wp);

   /**
    * Remove the waypoint named by wpName from the library. If wpName is not in the library
    * then false is returned. If a library entry was removed, then true is returned.
    **/
   public boolean remove(String wpName);

   /**
    * Get the waypoint named by wpName. If the library does not contain a waypoint named
    * wpName, then a waypoint is returned that contains zero for double values and null/unknown
    * or empty strings for string values.
    **/
   public Waypoint get(String wpName);

   /**
    * Get a string array of the names of waypoints in the library.
    **/
   public String[] getNames();

   /**
    * Get a string array of the names of categories in the library.
    **/
   public String[] getCategoryNames();

   /**
    * Get a string array of the waypoint names having the category aCat.
    **/
   public String[] getNamesInCategory(String aCat);

   /**
    * calculate the great-circle distance in statue miles from the waypoint from to the waypoint to
    **/
   public double distanceGCTo(Waypoint from, Waypoint to, int scale);

   /**
    * calculate the initial heading in a great-circle course from the waypoint from to
    * the waypoint to.
    **/
   public double bearingGCInitTo(Waypoint from, Waypoint to, int scale);
}
