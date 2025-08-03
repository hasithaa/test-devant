import ballerina/http;
import ballerina/io;
import ballerina/os;

string serviceurl = os:getEnv("CHOREO_ECHO1_SERVICEURL");
string choreoapikey = os:getEnv("CHOREO_ECHO1_CHOREOAPIKEY");
configurable string servicePath = "/abc/echo";

public function main() returns error? {
    io:println("Hello, World!");
    io:println("Service URL: ", serviceurl);
    io:println("Choreo API Key: ", choreoapikey);

    http:Client httpClient = check new (serviceurl);
    map<string|string[]>? headers = {
        "Choreo-API-Key": choreoapikey
    };
    // Provide the correct resource path
    http:Response payload = check httpClient->get(servicePath + "?message=Hello", headers);
    string response = check payload.getTextPayload();
    io:println("Response from echo service: ", response);
}
