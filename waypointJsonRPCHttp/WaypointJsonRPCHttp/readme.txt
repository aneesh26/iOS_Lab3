Author: Tim Lindquist (Tim.Lindquist@asu.edu)
        Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
Version: February 2015

See http://pooh.poly.asu.edu/Ser423

Purpose: Sample project showing Java waypoint service with JsonRPC

The Java server does the Json encoding/decoding using Douglas Crockford's
JSON-Java library which you will find at:

https://github.com/douglascrockford/JSON-java

The projects lib directory contains the classes for Crockford's JSON-Java
library in the file json.jar. The javadocs for Crockfords JSON-Java library
are in the doc directory.

The lib directory also contains the server as an executable jar file in the
file server.jar. The server is constructed as a threaded socket server that
receives http posts to which there has been attached a JsonRPC 2.0 method
call json object.

To compile both the server and client, and to build the executable jar
files run:
ant build.all

To run the server from a command line in the project directory execute:
java -jar lib/server.jar 8080

To test the server, there are sample curl commands that call methods
implemented by the server. The samples add a waypoint, get the names of all
waypoints, and remove a waypoint.

To run the client, which is a command line program, run:
java -jar lib/client.jar http://localhost:8080

Change the hostname (localhost) and/or port (8080) as required. These tell
the client which machine is running the server, and what port its listening
on.

There is included a sample java client, that also uses Crockford's JSON-Java
library. The ant build.all builds the file: lib/client.jar which is also an
executable jar file.

