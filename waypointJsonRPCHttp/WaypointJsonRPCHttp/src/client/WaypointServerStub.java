package ser423.jsonrpc;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.StringTokenizer;
import java.util.Vector;
import java.net.URL;
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
 * The client and service are both written in Java and they 
 * communicate using JSON-RPC.
 * <p/>
 * This class implements the waypoint server interface
 *
 * @author Tim Lindquist
 * @version 2/8/2015
 **/
public class WaypointServerStub extends Object implements WaypointServer{

   public String serviceURL;
   public JsonRpcRequestViaHttp server;
   public static int id = 0;
   private static final boolean debugOn = false;

   public WaypointServerStub (String serviceURL) {
      this.serviceURL = serviceURL;
      try{
         this.server = new JsonRpcRequestViaHttp(new URL(serviceURL));
      }catch (Exception ex){
         System.out.println("Malformed URL "+ex.getMessage());
      }
   }

   private void debug(String message) {
      if (debugOn)
         System.out.println("debug: "+message);
   }

   private String packageWaypointCall(String oper, String arg1, String arg2){
      JSONObject jsonObj = new JSONObject();
/*
 * the following code to create the array should, but does not work correctly
 * for doubles that are whole numbers.
 * That is, for + 2.0 3.0 it produces the json array [2,3]
 * To make the server see double/float values, roll my own to get [2.00,3.00]
 * This has the disadvantage that it removes any more than two places of accuracy,
 * but hey, its an class example.
      JSONArray anArr = new JSONArray();
      anArr.put(left);
      anArr.put(right);
      jsonObj.put("params",anArr);
 */
      jsonObj.put("jsonrpc","2.0");
      jsonObj.put("method",oper);
      jsonObj.put("id",++id);
      String almost = jsonObj.toString();
      String toInsert = null;
      if(arg1==null){ //no parameters
         toInsert = ",\"params\":[]";
      }else if(arg2==null){ //ar1 is only parameter
         toInsert = ",\"params\":[\""+arg1+"\"]";
      }else{ //arg1 and arg2 are both parameters
         toInsert = ",\"params\":[\""+arg1+"\",\""+arg2+"\"]";
      }
      String begin = almost.substring(0,almost.length()-1);
      String end = almost.substring(almost.length()-1);
      String ret = begin + toInsert + end;
      return ret;
   }

   private String packageWaypointCall(String oper, JSONObject arg1){
      JSONObject jsonObj = new JSONObject();
      jsonObj.put("jsonrpc","2.0");
      jsonObj.put("method",oper);
      jsonObj.put("id",++id);
      String almost = jsonObj.toString();
      String toInsert = null;
      if(arg1==null){ //no parameters
         toInsert = ",\"params\":[]";
      }else { //ar1 is only parameter
         toInsert = ",\"params\":["+arg1.toString()+"]";
      }
      String begin = almost.substring(0,almost.length()-1);
      String end = almost.substring(almost.length()-1);
      String ret = begin + toInsert + end;
      return ret;
   }

   public boolean resetWaypoints(){
      boolean result = false;
      try{
         String jsonStr = this.packageWaypointCall("resetWaypoints",null,null);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         result = res.optBoolean("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to getNames: "+ex.getMessage());
      }
      return result;
   }

   public boolean add(Waypoint wp){
      boolean result = false;
      try{
         JSONObject wpJson = wp.toJson();
         String jsonStr = this.packageWaypointCall("add",wpJson);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         result = res.optBoolean("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to add: "+ex.getMessage());
      }
      return result;
   }

   public boolean remove(String wpName){
      boolean result = false;
      try{
         String jsonStr = this.packageWaypointCall("remove",wpName,null);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         result = res.optBoolean("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to remove: "+ex.getMessage());
      }
      return result;
   }

   public Waypoint get(String wpName){
      Waypoint result = null;
      try{
         String jsonStr = this.packageWaypointCall("get",wpName,null);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         JSONObject resObj = res.optJSONObject("result");
         result = new Waypoint(resObj);
      }catch(Exception ex){
         System.out.println("exception in rpc call to get: "+ex.getMessage());
      }
      return result;
   }

   public String[] getNames(){
      String[] result = null;
      try{
         String jsonStr = this.packageWaypointCall("getNames",null,null);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         String resArrStr = res.optString("result");
         JSONArray nameArr = new JSONArray(resArrStr);
         Vector<String> vec = new Vector<String>();
         for (int i =0; i<nameArr.length(); i++){
            vec.add(nameArr.optString(i));
         }
         result = vec.toArray(new String[]{});
      }catch(Exception ex){
         System.out.println("exception in rpc call to getNames: "+ex.getMessage());
      }
      return result;
   }

   public String[] getNamesInCategory(String category){
      String[] result = null;
      try{
         String jsonStr = this.packageWaypointCall("getNamesInCategory",category,null);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         String resArrStr = res.optString("result");
         JSONArray nameArr = new JSONArray(resArrStr);
         Vector<String> vec = new Vector<String>();
         for (int i =0; i<nameArr.length(); i++){
            vec.add(nameArr.optString(i));
         }
         result = vec.toArray(new String[]{});
      }catch(Exception ex){
         System.out.println("exception in rpc call to getNames: "+ex.getMessage());
      }
      return result;
   }

   public String[] getCategoryNames(){
      String[] result = null;
      try{
         String jsonStr = this.packageWaypointCall("getCategoryNames",null,null);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         String resArrStr = res.optString("result");
         JSONArray nameArr = new JSONArray(resArrStr);
         Vector<String> vec = new Vector<String>();
         for (int i =0; i<nameArr.length(); i++){
            vec.add(nameArr.optString(i));
         }
         result = vec.toArray(new String[]{});
      }catch(Exception ex){
         System.out.println("exception in rpc call to getNames: "+ex.getMessage());
      }
      return result;
   }

   public double distanceGCTo(String from, String to){
      double result = 0;
      try{
         String jsonStr = this.packageWaypointCall("distanceGCTo",from,to);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         result = res.optDouble("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to distanceGCTo: "+ex.getMessage());
      }
      return result;
   }

   public double bearingGCInitTo(String from, String to){
      double result = 0;
      try{
         String jsonStr = this.packageWaypointCall("bearingGCInitTo",from,to);
         debug("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         debug("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         result = res.optDouble("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to bearingGCInitTo: "+ex.getMessage());
      }
      return result;
   }

   public static void main(String args[]) {
      try {
         String url = "http://127.0.0.1:8080/";
         if(args.length > 0){
            url = args[0];
         }
         WaypointServerStub cjc = new WaypointServerStub(url);
         BufferedReader stdin = new BufferedReader(
            new InputStreamReader(System.in));
         System.out.print("Enter end or {remove|resetWaypoints|get|getNames|getCategoryNames|getNamesInCategory|dist|bear} arg1 arg2 \nEg  remove Toreros >");
         String inStr = stdin.readLine();
         StringTokenizer st = new StringTokenizer(inStr);
         String opn = st.nextToken();
         while(!opn.equalsIgnoreCase("end")) {
            if(opn.equalsIgnoreCase("remove")){
               boolean result = cjc.remove(st.nextToken());
               System.out.println("response: "+result);
            }else if (opn.equalsIgnoreCase("resetWaypoints")) {
               boolean result = cjc.resetWaypoints();
               System.out.println("response: "+result);
            }else if (opn.equalsIgnoreCase("get")) {
               Waypoint result = cjc.get(st.nextToken());
               System.out.println("response: "+result.toJsonString());
            }else if (opn.equalsIgnoreCase("getNames")) {
               String[] result = cjc.getNames();
               for (int i=0; i< result.length; i++){
                  System.out.println("response["+i+"] is "+result[i]);
               }
            }else if (opn.equalsIgnoreCase("getCategoryNames")) {
               String[] result = cjc.getCategoryNames();
               for (int i=0; i< result.length; i++){
                  System.out.println("response["+i+"] is "+result[i]);
               }
            }else if (opn.equalsIgnoreCase("getNamesInCategory")) {
               String[] result = cjc.getNamesInCategory(st.nextToken());
               for (int i=0; i< result.length; i++){
                  System.out.println("response["+i+"] is "+result[i]);
               }
            }else if (opn.equalsIgnoreCase("dist")) {
               double result = cjc.distanceGCTo(st.nextToken(),st.nextToken());
               System.out.println("response: "+result);
            }else if (opn.equalsIgnoreCase("bear")) {
               double result = cjc.bearingGCInitTo(st.nextToken(),
                                                   st.nextToken());
               System.out.println("response: "+result);
            }
            System.out.print("Enter end or {remove|get|getNames|getCategoryNames|getNamesInCategory|dist|bear} arg1 arg2 \nEg  remove Toreros >");
            inStr = stdin.readLine();
            st = new StringTokenizer(inStr);
            opn = st.nextToken();
         }
      }catch (Exception e) {
         System.out.println("Oops, you didn't enter the right stuff");
      }
   }
}
