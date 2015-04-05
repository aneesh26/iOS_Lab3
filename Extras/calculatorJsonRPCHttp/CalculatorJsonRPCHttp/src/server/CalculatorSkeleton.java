package ser423;

import java.net.*;
import java.io.*;
import java.util.*;
import org.json.JSONObject;
import org.json.JSONArray;
import java.text.NumberFormat;

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
public class CalculatorSkeleton extends Object {

   CalculatorImpl ci; //the calculator implementation

   public CalculatorSkeleton (){
      super();
      ci = new CalculatorImpl();
   }

   public String callMethod(String request){
      JSONObject result = new JSONObject();
      NumberFormat nf = NumberFormat.getInstance();
      nf.setMaximumFractionDigits(2);
      try{
         JSONObject theCall = new JSONObject(request);
         String method = theCall.getString("method");
         int id = theCall.getInt("id");
         JSONArray params = null;
         if(!theCall.isNull("params")){
            params = theCall.getJSONArray("params");
         }
         result.put("id",id);
         result.put("jsonrpc","2.0");
         double left = 0;
         double right = 0;
         if(params.length()>0){
            left = params.getDouble(0);
         } if(params.length()>1){
            right = params.getDouble(1);
         }
         if(method.equals("add")){
            double res = ci.add(left, right);
            System.out.println("request: "+nf.format(left)+" + "
                               + nf.format(right)+ " result: "
                               + nf.format(res));
            result.put("result", res);
         }else if(method.equals("subtract")){
            double res = ci.subtract(left, right);
            System.out.println("request: "+nf.format(left)+" - "
                               + nf.format(right)+ " result: "
                               + nf.format(res));
            result.put("result", res);
         }else if(method.equals("multiply")){
            double res = ci.multiply(left, right);
            System.out.println("request: "+nf.format(left)+" * "
                               + nf.format(right)+ " result: "
                               + nf.format(res));
            result.put("result", res);
         }else if(method.equals("divide")){
            double res = ci.divide(left, right);
            System.out.println("request: "+nf.format(left)+" / "
                               + nf.format(right)+ " result: "
                               + nf.format(res));
            result.put("result", res);
         }else if(method.equals("whoAreYou")){
            System.out.println("request: whoAreYou");
            result.put("result",ci.whoAreYou());
         }
      }catch(Exception ex){
         System.out.println("exception in callMethod: "+ex.getMessage());
      }
      return "HTTP/1.0 200 Data follows\nServer:localhost:8080\nContent-Type:text/plain\nContent-Length:"+(result.toString()).length()+"\n\n"+result.toString();
   }
}

