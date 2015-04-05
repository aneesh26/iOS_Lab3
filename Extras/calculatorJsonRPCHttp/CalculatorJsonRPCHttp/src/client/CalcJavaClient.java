package ser423.client;

import java.io.*;
import java.util.*;
import java.net.URL;
import org.json.JSONObject;
import org.json.JSONArray;

/**
 * Copyright (c) 2014 Tim Lindquist,
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
 * computing class at ASU Poly. The application provides a calculator service.
 * The client and service are both written in Java and they 
 * communicate using JSON-RPC.
 * <p/>
 * The Caclulator interface provides the method definitions used by the client
 * and implemented by the calculator service.
 *
 * @author Tim Lindquist
 * @version 2/1/2015
 **/
public class CalcJavaClient extends Object {

   public String serviceURL;
   public JsonRpcRequestViaHttp server;
   public static int id = 0;

   public CalcJavaClient (String serviceURL) {
      this.serviceURL = serviceURL;
      try{
         this.server = new JsonRpcRequestViaHttp(new URL(serviceURL));
      }catch (Exception ex){
         System.out.println("Malformed URL "+ex.getMessage());
      }
   }

   private String packageCalcCall(String oper, double left, double right){
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
      String toInsert = ",\"params\":["+ String.format("%.2f", left)
                        + "," + String.format("%.2f", right) + "]";
      String begin = almost.substring(0,almost.length()-1);
      String end = almost.substring(almost.length()-1);
      String ret = begin + toInsert + end;
      return ret;
   }

   /**
    * Add two numbers
    * @return The sum
    */
   public double add(double left, double right){
      double result = 0;
      try{
         String jsonStr = this.packageCalcCall("add",left,right);
         //System.out.println("sending: "+jsonStr);
         String resString = server.call(jsonStr);
         //System.out.println("got back: "+resString);
         JSONObject res = new JSONObject(resString);
         result = res.optDouble("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to plus: "+ex.getMessage());
      }
      return result;
   }

   /**
    * Subtract two numbers
    * @return The difference
    */
   public double subtract(double left, double right){
      double result = 0;
      try{
         String jsonStr = this.packageCalcCall("subtract",left,right);
         String resString = server.call(jsonStr);
         JSONObject res = new JSONObject(resString);
         result = res.optDouble("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to plus: "+ex.getMessage());
      }
      return result;
   }

   /**
    * Multiply two numbers
    * @return The product
    */
   public double multiply(double left, double right){
      double result = 0;
      try{
         String jsonStr = this.packageCalcCall("multiply",left,right);
         String resString = server.call(jsonStr);
         JSONObject res = new JSONObject(resString);
         result = res.optDouble("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to plus: "+ex.getMessage());
      }
      return result;
   }

   /**
    * Divide two numbers
    * @return left / right
    */
   public double divide(double left, double right){
      double result = 0;
      try{
         String jsonStr = this.packageCalcCall("divide",left,right);
         String resString = server.call(jsonStr);
         JSONObject res = new JSONObject(resString);
         result = res.optDouble("result");
      }catch(Exception ex){
         System.out.println("exception in rpc call to plus: "+ex.getMessage());
      }
      return result;
   }

   /**
    * Get the service information.
    * @return The service information
    */
   public String serviceInfo(){
      return "Service information";
   }

   public static void main(String args[]) {
      try {
         String url = "http://127.0.0.1:8080/";
         if(args.length > 0){
            url = args[0];
         }
         CalcJavaClient cjc = new CalcJavaClient(url);
         BufferedReader stdin = new BufferedReader(
            new InputStreamReader(System.in));
         System.out.print("Enter end or {+|-|*|/} double double eg + 3 5 >");
         String inStr = stdin.readLine();
         StringTokenizer st = new StringTokenizer(inStr);
         String opn = st.nextToken();
         while(!opn.equalsIgnoreCase("end")) {
            if(opn.equalsIgnoreCase("+")){
               double result = cjc.add(Double.parseDouble(st.nextToken()),
                                        Double.parseDouble(st.nextToken()));
               System.out.println("response: "+result);
            }else if (opn.equalsIgnoreCase("-")) {
               double result = cjc.subtract(Double.parseDouble(st.nextToken()),
                                        Double.parseDouble(st.nextToken()));
               System.out.println("response: "+result);
            }else if (opn.equalsIgnoreCase("*")) {
               double result = cjc.multiply(Double.parseDouble(st.nextToken()),
                                        Double.parseDouble(st.nextToken()));
               System.out.println("response: "+result);
            }else if (opn.equalsIgnoreCase("/")) {
               double result = cjc.divide(Double.parseDouble(st.nextToken()),
                                        Double.parseDouble(st.nextToken()));
               System.out.println("response: "+result);
            }
            System.out.print("Enter end or {+|-|*|/} double double eg + 3 5 >");
            inStr = stdin.readLine();
            st = new StringTokenizer(inStr);
            opn = st.nextToken();
         }
      }catch (Exception e) {
         System.out.println("Oops, you didn't enter the right stuff");
      }
   }
}
