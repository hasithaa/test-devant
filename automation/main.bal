import ballerina/io;
import ballerina/os;

configurable string serviceurl = os:getEnv("CHOREO_ECHO_SERVICEURL");
configurable string choreoapikey = os:getEnv("CHOREO_ECHO_CHOREOAPIKEY");

public function main() returns error? {
    io:println("Hello, World!");
    io:println("Service URL: ", serviceurl);
    io:println("Choreo API Key: ", choreoapikey);
}
