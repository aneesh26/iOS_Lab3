package ser423;

import java.net.*;
import java.io.*;
import java.util.*;

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
 * This class provides the waypoint server by waiting for connection requests
 * (posts) from clients and processing the requests. The WaypointServer is a
 * Threaded TCP/IP socket server the communicates with the clients via a
 * byte array. Each client connection is serviced by a new (WaypointServer)
 * thread. The thread searches for the jsonrpc request object, and passes it
 * to the appropriate method via the skeleton.
 *
 * @author Tim Lindquist
 * @version 2/8/2015
 **/
public class WaypointServer extends Thread {
   private Socket conn;
   private int id;
   WaypointLibrary wpLib;
   LibrarySkeleton skeleton;

   public WaypointServer (Socket sock, int id, WaypointLibrary wpLib) {
      this.conn = sock;
      this.id = id;
      this.wpLib = wpLib;
      skeleton = new LibrarySkeleton(wpLib);
   }

   public void run() {
      try {
         OutputStream outSock = conn.getOutputStream();
         InputStream inSock = conn.getInputStream();
         byte clientInput[] = new byte[4096]; // up to 1024 bytes in a message.
         int numr = inSock.read(clientInput,0,4096);
         if (numr != -1) {
            //System.out.println("read "+numr+" bytes. Available: "+
            //                   inSock.available());
            Thread.sleep(200);
            int ind = numr;
            while(inSock.available()>0){
               numr = inSock.read(clientInput,ind,4096-ind);
               ind = numr + ind;
               Thread.sleep(200);
            }
            String clientString = new String(clientInput,0,ind);
            //System.out.println("read from client: "+id+" the string: "
            //                   +clientString);
            if(clientString.indexOf("{")>=0){
               String request = clientString.substring(clientString.indexOf("{"));
               System.out.println("request from client: "+request);
               String response = skeleton.callMethod(request);
               byte clientOut[] = response.getBytes();
               outSock.write(clientOut,0,clientOut.length);
              //System.out.println("response is: "+response);
            }else{
               System.out.println("No json object in clientString: "+
                                  clientString);
            }
         }
         inSock.close();
         outSock.close();
         conn.close();
      } catch (Exception e) {
         System.out.println("Can't get I/O for the connection.");
      }
   }

   public static void main (String args[]) {
      Socket sock;
      WaypointLibrary wpLib;
      int id=0;
      int portNo = 8080;
      try {
         if (args.length < 1) {
            System.out.println("Usage: java -jar lib/server.jar portNum");
            System.exit(0);
         }
         portNo = Integer.parseInt(args[0]);
         wpLib = new WaypointLibraryImpl();
         if (portNo <= 1024) portNo=8080;
         ServerSocket serv = new ServerSocket(portNo);
         while (true) {
            System.out.println("Waypoint server waiting for connects on port "
                               +portNo);
            sock = serv.accept();
            System.out.println("Waypoint server connected to client: "+id);
            WaypointServer myServerThread = new WaypointServer(sock,id++,wpLib);
            myServerThread.start();
         }
      } catch(Exception e) {e.printStackTrace();}
   }
}
