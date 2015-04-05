package ser423;

import java.net.*;
import java.io.*;
import java.util.*;
import org.json.JSONObject;
import org.json.JSONArray;

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
 * This class serves as the server's skeleton in that it converts jsonrpc calls
 * into calls to the appropriate library service and then returns the result
 * as a json object.
 *
 * @author Tim Lindquist
 * @version 2/8/2015
 **/
public class LibrarySkeleton extends Object {

   WaypointLibrary wpLib;

   public LibrarySkeleton (WaypointLibrary wpLib){
      this.wpLib = wpLib;
   }

   public String callMethod(String request){
      JSONObject result = new JSONObject();
      try{
         JSONObject theCall = new JSONObject(request);
         String method = theCall.getString("method");
         int id = theCall.getInt("id");
         JSONArray params = null;
        
         if(!theCall.isNull("params")){
            params = theCall.getJSONArray("params");
         }
            System.out.println("JSONArray:" + params);
         result.put("id",id);
         result.put("jsonrpc","2.0");
         if(method.equals("add")){
             
            JSONObject wpJson = params.getJSONObject(0);
            
             
            Waypoint wpToAdd = new Waypoint(wpJson);
            System.out.println("adding wp: "+wpToAdd.toJsonString());
            wpLib.add(wpToAdd);
            result.put("result",true);
         }else if(method.equals("resetWaypoints")){
            wpLib.resetWaypoints();
            result.put("result",true);
         }else if(method.equals("remove")){
            String wpName = params.getString(0);
            boolean removed = wpLib.remove(wpName);
            result.put("result",removed);
         }else if(method.equals("modify")){
            String wpStr = params.getString(0);
            Waypoint wpToAdd = new Waypoint(wpStr);
            wpLib.add(wpToAdd);
            result.put("result",true);
         }else if(method.equals("get")){
             JSONObject wpJson1 = params.getJSONObject(0);
             String wpName = wpJson1.getString("name");
             //params.getString(1);
            Waypoint wp = wpLib.get(wpName);
            JSONObject wpJson = wp.toJson();
            result.put("result",wpJson);
         }else if(method.equals("getNames")){
            String[] names = wpLib.getNames();
            JSONArray resArr = new JSONArray();
            for (int i=0; i<names.length; i++){
               resArr.put(names[i]);
            }
            result.put("result",resArr);
         }else if(method.equals("getCategoryNames")){
            String[] names = wpLib.getCategoryNames();
            JSONArray resArr = new JSONArray();
            for (int i=0; i<names.length; i++){
               resArr.put(names[i]);
            }
            result.put("result",resArr);
         }else if(method.equals("getNamesInCategory")){
            String catName = params.getString(0);
            String[] names = wpLib.getNamesInCategory(catName);
            JSONArray resArr = new JSONArray();
            for (int i=0; i<names.length; i++){
               resArr.put(names[i]);
            }
            result.put("result",resArr);
         }else if(method.equals("distanceGCTo")){
            System.out.println("how many parameters? "+params.length());
            if(params.length()==2){
               String fromName = params.getString(0);
               Waypoint fromWP = wpLib.get(fromName);
               String toName = params.getString(1);
               Waypoint toWP = wpLib.get(toName);
               //System.out.println("getting dist from "+fromName+" to "+ toName);
               //System.out.println("from wps "+fromWP.name+" to "+ toWP.name);
               double distance = wpLib.distanceGCTo(fromWP,toWP,
                                                    Waypoint.STATUTE);
               result.put("result",distance);
            }else{
               result.put("result",0.0);
            }
         }else if(method.equals("bearingGCInitTo")){
            if(params.length()==2){
               String fromName = params.getString(0);
               Waypoint fromWP = wpLib.get(fromName);
               String toName = params.getString(1);
               Waypoint toWP = wpLib.get(toName);
               double bearing = wpLib.bearingGCInitTo(fromWP,toWP,
                                                      Waypoint.STATUTE);
               result.put("result",bearing);
            }else{
               result.put("result",0.0);
            }
         }
      }catch(Exception ex){
         System.out.println("exception in callMethod: "+ex.getMessage());
      }
      System.out.println("returning: "+result.toString());
      return "HTTP/1.0 200 Data follows\nServer:localhost:8080\nContent-Type:text/plain\nContent-Length:"+(result.toString()).length()+"\n\n"+result.toString();
   }
}

