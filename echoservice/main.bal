import ballerina/http;


service /abc on new http:Listener(9090) {

    resource function get echo(string message) returns string {
        return "Echo: " + message;
    }

    resource function post echo(string message) returns string {
        return "Echo: " + message;
    }

}
