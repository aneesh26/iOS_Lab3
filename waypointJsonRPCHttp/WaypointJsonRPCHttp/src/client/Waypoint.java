package ser423.jsonrpc;

import java.io.Serializable;
import org.json.JSONObject;
import java.util.Map;
import java.util.HashMap;

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
 * This class encapsulates a waypoint and provides for serialization and
 * de-serialization of waypoint objects.
 *
 * @author Tim Lindquist
 * @version 2/8/2015
 **/
public class Waypoint extends Object implements Serializable {

   public final static int STATUTE = 0;
   public final static int NAUTICAL = 1;
   public final static int KMETER = 2;
   public final static double radiusE = 6371;

   public double lat; // degrees lat in DD.D format (+ north, - south)
   public double lon; // degrees lon in DD.D format (+ east, - west)
   public double ele; // elevation in feet MSL
   public String name; // a name for the waypoint
   public String address; // a street address for the waypoint
   public String category; // a category for this waypoint (hike, travel, restaurants, eg)

   public Waypoint(double lat, double lon, double ele, String name,
                   String addr, String cat){
      this.lat = lat;
      this.lon = lon;
      this.ele = ele;
      this.name = name;
      this.address = addr;
      this.category = cat;
   }

   public Waypoint(JSONObject jsonObj){
      try{
         lat = jsonObj.getDouble("lat");
         lon = jsonObj.getDouble("lon");
         ele = jsonObj.getDouble("ele");
         name = jsonObj.getString("name");
         address = jsonObj.getString("address");
         category = jsonObj.getString("category");
      }catch(Exception ex){
         System.out.println("Exception constructing waypoint from JSON: "
                            + ex.getMessage());
      }
   }

   public Waypoint(String jsonString){
      try{
         System.out.println("constructor from json received: "+jsonString);
         JSONObject obj = new JSONObject(jsonString);
         lat = obj.getDouble("lat");
         lon = obj.getDouble("lon");
         ele = obj.getDouble("ele");
         name = obj.getString("name");
         address = obj.getString("address");
         category = obj.getString("category");
         System.out.println("constructed "+this.toJsonString()+" from json");
      }catch(Exception ex){
         System.out.println("Exception constructing waypoint from string: "
                            + ex.getMessage());
      }
   }

   public String toJsonString(){
      String ret = "{}";
      try{
         JSONObject obj = new JSONObject();
         obj.put("lat",new Double(lat));
         obj.put("lon",new Double(lon));
         obj.put("ele",new Double(ele));
         obj.put("name",name);
         obj.put("address",address);
         obj.put("category",category);
         ret = obj.toString(0);
      }catch(Exception ex){
         System.out.println("Exception: "+ex.getMessage());
      }
      return ret;
   }

   public JSONObject toJson(){
      JSONObject obj = new JSONObject();
      try{
         obj.put("lat",new Double(lat));
         obj.put("lon",new Double(lon));
         obj.put("ele",new Double(ele));
         obj.put("name",name);
         obj.put("address",address);
         obj.put("category",category);
      }catch(Exception ex){
         System.out.println("Exception: "+ex.getMessage());
      }
      return obj;
   }

   public Map<String,Object> toMap(){
      Map<String,Object> obj = new HashMap<String,Object>();
      try{
         obj.put("lat",new Double(lat));
         obj.put("lon",new Double(lon));
         obj.put("ele",new Double(ele));
         obj.put("name",name);
         obj.put("address",address);
         obj.put("category",category);
      }catch(Exception ex){
         System.out.println("Exception: "+ex.getMessage());
      }
      return obj;
   }
}
