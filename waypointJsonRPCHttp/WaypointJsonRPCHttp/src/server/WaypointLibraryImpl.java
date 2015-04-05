package ser423;

import java.lang.Math;
import java.text.NumberFormat;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.ArrayList;
import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;

import org.json.JSONObject;
import org.json.JSONTokener;

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
 * This class provides a library of waypoint objects. The class implements
 * the operations defined in the WaypointLibrary interface by storing a
 * collection of waypoint objects in a hashtable. The key is the waypoint
 * name (assumed to be unique), and the value is the corresponding
 * Waypoint object.
 *
 * @author Tim Lindquist
 * @version 2/8/2015
 **/
class WaypointLibraryImpl extends Object implements WaypointLibrary {

   protected Hashtable<String,Waypoint> points;
   public final static double radiusE = 6371;
   private static final boolean debugOn = false;

   public WaypointLibraryImpl() {
      points = new Hashtable<String,Waypoint>();
      this.resetWaypoints();
   }

   public WaypointLibraryImpl(String initFileName) {
      try{
         points = new Hashtable<String,Waypoint>();
         debug("searching for file: "+initFileName);
         File f = new File(initFileName);
         if(f.exists() && !f.isDirectory()) {
            debug("samples.txt found");
            BufferedReader fileIn = new BufferedReader(new FileReader(f));
            String inStr;
            String st[];
            double lat, lon, ele = 0;
            String name;
            NumberFormat nf = NumberFormat.getInstance();
            nf.setMaximumFractionDigits(2);
            while((inStr = fileIn.readLine())!=null) {
               st = inStr.split(" ");
               lat = Double.parseDouble(st[0]);
               lon = Double.parseDouble(st[1]);
               ele = Double.parseDouble(st[2]);
               name = st[3];
               Waypoint wp = new Waypoint(lat, lon, ele, name, "", "Unknown");
               debug("init with waypoint: "+name+
                     " lat "+nf.format(lat)+
                     " lon "+nf.format(lon)+
                     " ele "+nf.format(ele));
               points.put(name,wp);
            }
         }
      }catch (Exception e) {
         e.printStackTrace();
      }
   }

   private void debug(String message) {
      if (debugOn)
         System.out.println("debug: "+message);
   }

   public void resetWaypoints(){
      try{
         points.clear();
         String fileName = "waypoints.json";
         File f = new File(fileName);
         FileInputStream is = new FileInputStream(f);
         JSONObject wpts = new JSONObject(new JSONTokener(is));
         Iterator<String> it = wpts.keys();
         while (it.hasNext()){
            String wpName = it.next();
            JSONObject aWpt = wpts.optJSONObject(wpName);
            System.out.println("importing waypoint "+wpName);
            debug("importing waypoint named "+wpName+ " json is: "+aWpt.toString());
            if (aWpt != null){
               Waypoint wp = new Waypoint(aWpt);
               points.put(wpName, wp);
            }
         }
      }catch (Exception ex){
         System.out.println("Exception reading waypoints.json: "+ex.getMessage());
      }
   }

   public void add(Waypoint wp){
      debug("adding wp named: "+wp.name);
      points.put(wp.name, wp);
   }

   public boolean remove(String wpName){
      boolean ret = false;
      debug("removing wp named: "+wpName);
      if(points.containsKey(wpName)){
         points.remove(wpName);
         ret = true;
      }
      return ret;
   }

   public void modify(Waypoint wp, String wpName){
      debug("modifying wp named: "+wpName);
      points.put(wpName,wp);
   }

   public Waypoint get(String wpName){
      Waypoint ret = new Waypoint(0,0,0,"Null","","Unknown");
      debug("getting wp named: "+wpName);
      if(points.containsKey(wpName)){
         ret = points.get(wpName);
      }
      return ret;
   }

   public String[] getNames(){
      String[] ret = {};
      debug("getting "+points.size()+" waypoint names.");
      if(points.size()>0){
         ret = (String[])(points.keySet()).toArray(new String[0]);
      }
      return(ret);
   }

   public String[] getCategoryNames(){
      String[] aRet = {};
      String[] ret = (String[])(points.keySet()).toArray(new String[0]);
      ArrayList<String> al = new ArrayList<String>();
      for(int i=0; i< ret.length; i++){
         Waypoint wp = points.get(ret[i]);
         if(!al.contains(wp.category)){
            al.add(wp.category);
         }
      }
      if(al.size()>0){
         aRet = al.toArray(new String[0]);
      }
      return(aRet);
   }
   
   public String[] getNamesInCategory(String aCat){
      String[] aRet = {};
      String[] ret = (String[])(points.keySet()).toArray(new String[0]);
      ArrayList<String> al = new ArrayList<String>();
      for(int i=0; i< ret.length; i++){
         Waypoint wp = points.get(ret[i]);
         if(wp.category.equals(aCat)){
            al.add(wp.name);
         }
      }
      if(al.size()>0){
         aRet = al.toArray(new String[0]);
      }
      return(aRet);
   }

   public double distanceRhumbTo(Waypoint from, Waypoint to, int scale){
      debug("rhumb distance from "+from.name+" to "+to.name);
      double ret = 0.0;
      double dsi, q;
      double dlatRad = Math.toRadians(to.lat - from.lat);
      double dlonRad = Math.toRadians(to.lon - from.lon);
      double latOrgRad = Math.toRadians(from.lat);
      double lonOrgRad = Math.toRadians(from.lon);
      dsi = Math.log(Math.tan(Math.PI/4.0 + Math.toRadians(to.lat)/2.0)/
                     Math.tan(Math.PI/4.0+latOrgRad/2.0));
      q = Math.abs(dlatRad) > 10e-12 ? dlatRad/dsi :
                                       Math.cos(latOrgRad);
      ret = Math.sqrt(dlatRad*dlatRad + q * q * dlonRad * dlonRad) * 6371.0;
      switch(scale) {
      case Waypoint.STATUTE:
         ret = ret * 0.62137119;
         break;
      case Waypoint.NAUTICAL:
         ret = ret * 0.5399568;
         break;
      }
      return ret;
   }

   public double distanceGCTo(Waypoint from, Waypoint to, int scale){
      debug("great circle distance from "+from.name+" to " + to.name);
      double ret = 0.0;
      double dlatRad = Math.toRadians(to.lat - from.lat);
      double dlonRad = Math.toRadians(to.lon - from.lon);
      double latOrgRad = Math.toRadians(from.lat);
      double lonOrgRad = Math.toRadians(from.lon);
      double a = Math.sin(dlatRad/2) * Math.sin(dlatRad/2) +
         Math.sin(dlonRad/2) * Math.sin(dlonRad/2) * Math.cos(latOrgRad) *
         Math.cos(Math.toRadians(to.lat));
      ret = radiusE * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)));
      // ret is in kilometers. switch to either Statute or Nautical?
      switch(scale) {
      case Waypoint.STATUTE:
         ret = ret * 0.62137119;
         break;
      case Waypoint.NAUTICAL:
         ret = ret * 0.5399568;
         break;
      }
      return ret;
   }

   public double bearingGCInitTo(Waypoint from, Waypoint to, int scale){
      debug("great circle bearing from "+from.name+" to "+
                         to.name);
      double ret = 0.0;
      double dlatRad = Math.toRadians(to.lat - from.lat);
      double dlonRad = Math.toRadians(to.lon - from.lon);
      double latOrgRad = Math.toRadians(from.lat);
      double lonOrgRad = Math.toRadians(from.lon);
      double y = Math.sin(dlonRad) * Math.cos(Math.toRadians(to.lat));
      double x = Math.cos(latOrgRad)*Math.sin(Math.toRadians(to.lat)) -
                 Math.sin(latOrgRad)*Math.cos(Math.toRadians(to.lat))*
                 Math.cos(dlonRad);
      ret = Math.toDegrees(Math.atan2(y,x));
      ret = (ret+360.0) % 360.0;
      return ret;
   }

   public double bearingRhumbTo(Waypoint from, Waypoint to, int scale){
      debug("rhumb bearing from "+from.name+" to "+to.name);
      double ret = 0.0;
      double dlatRad = Math.toRadians(to.lat - from.lat);
      double dlonRad = Math.toRadians(to.lon - from.lon);
      double latOrgRad = Math.toRadians(from.lat);
      double lonOrgRad = Math.toRadians(from.lon);
      double dsi = Math.log(Math.tan(Math.PI/4.0+Math.toRadians(to.lat)/2.0)/
                            Math.tan(Math.PI/4.0 + latOrgRad/2.0));
      double q = Math.abs(dsi) > 10e-12 ? dlatRad/dsi : Math.cos(latOrgRad);
      if(Math.abs(dlonRad) > Math.PI)
         dlonRad = dlonRad>0.0 ? -1.0*(2.0*Math.PI - dlonRad) : 
                   2*(Math.PI+dlonRad);
      ret = Math.toDegrees(Math.atan2(dlonRad, dsi));
      ret = (ret+360.0) % 360.0;
      return ret;
   }
}
