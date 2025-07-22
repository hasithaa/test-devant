import ballerina/log;

public function main(string? vendorId = ()) returns error? {
    do {
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
