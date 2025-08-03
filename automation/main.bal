import ballerina/io;
import ballerina/os;

string serviceurl = os:getEnv("CHOREO_ECHO1_SERVICEURL");
string choreoapikey = os:getEnv("CHOREO_ECHO1_CHOREOAPIKEY");

public function main() returns error? {
    io:println("Hello, World!");
    io:println("Service URL: ", serviceurl);
    io:println("Choreo API Key: ", choreoapikey);
}
