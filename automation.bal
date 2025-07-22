import ballerina/log;

public function main(string? vendorId = ()) returns error? {
    do {
        log:printInfo("Starting the process to retrieve vendor configuration...", vendorId = vendorId, config = vendorConfig);
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
