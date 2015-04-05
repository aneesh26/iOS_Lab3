package ser423;
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
public class CalculatorImpl extends Object implements Calculator {
   public double add(double left, double right){
      return left + right;
   }
   public double subtract(double left, double right){
      return left - right;
   }
   public double multiply(double left, double right){
      return left * right;
   }
   public double divide(double numerator, double denominator){
      return numerator / denominator;
   }
   public String whoAreYou(){
      return "Me, why I am the java calculator service using json-rpc.";
   }
}
