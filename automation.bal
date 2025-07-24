import ballerina/log;
import ballerina/io;
import ballerina/file;
import ballerina/time;
import ballerina/random;

// Configuration constants
const int DEFAULT_FILE_SIZE_GB = 5;
const int LOGGING_INTERVAL_MB = 50;
const int BYTES_PER_MB = 1024 * 1024;
const int BYTES_PER_GB = BYTES_PER_MB * 1024;
const string TMP_DIRECTORY = "/tmp";
const string DEFAULT_FILENAME = "large_file.txt";

// Configurable parameters
configurable int fileSizeGB = DEFAULT_FILE_SIZE_GB;
configurable string outputDirectory = TMP_DIRECTORY;
configurable string fileName = DEFAULT_FILENAME;
configurable int logIntervalMB = LOGGING_INTERVAL_MB;

public function main() returns error? {
    log:printInfo("Starting large file generation process...");
    log:printInfo(string `Configuration: Size=${fileSizeGB}GB, LogInterval=${logIntervalMB}MB, Directory=${outputDirectory}`);
    
    do {
        check createLargeFile(fileSizeGB, outputDirectory, fileName, logIntervalMB);
        log:printInfo("File generation completed successfully!");
    } on fail error e {
        log:printError("Error occurred during file generation", 'error = e);
        return e;
    }
}

function createLargeFile(int sizeGB, string directory, string filename, int logIntervalMB) returns error? {
    // Calculate target size in bytes
    int targetSizeBytes = sizeGB * BYTES_PER_GB;
    int logIntervalBytes = logIntervalMB * BYTES_PER_MB;
    
    // Ensure directory exists
    check ensureDirectoryExists(directory);
    
    string|file:Error filePathResult = file:joinPath(directory, filename);
    if filePathResult is file:Error {
        return error(string `Failed to create file path: ${filePathResult.message()}`);
    }
    string filePath = filePathResult;
    log:printInfo(string `Creating file: ${filePath} (${sizeGB}GB)`);
    
    // Create and open file for writing
    io:WritableByteChannel|error fileChannel = io:openWritableFile(filePath);
    if fileChannel is error {
        return error(string `Failed to create file: ${fileChannel.message()}`);
    }
    
    int bytesWritten = 0;
    int nextLogThreshold = logIntervalBytes;
    time:Utc startTime = time:utcNow();
    
    while bytesWritten < targetSizeBytes {
        // Generate content for this chunk
        byte[] chunk = check generateChunk(targetSizeBytes - bytesWritten);
        
        // Write chunk to file
        int|error writeResult = fileChannel.write(chunk, 0);
        if writeResult is error {
            error? closeErr = fileChannel.close();
            if closeErr is error {
                log:printWarn(string `Failed to close file after write error: ${closeErr.message()}`);
            }
            return error(string `Failed to write to file: ${writeResult.message()}`);
        }
        
        bytesWritten += chunk.length();
        
        // Log progress at intervals
        if bytesWritten >= nextLogThreshold {
            decimal progressPercent = <decimal>bytesWritten / <decimal>targetSizeBytes * 100;
            decimal mbWritten = <decimal>bytesWritten / <decimal>BYTES_PER_MB;
            time:Utc currentTime = time:utcNow();
            decimal elapsedSeconds = <decimal>(currentTime[0] - startTime[0]) + <decimal>(currentTime[1] - startTime[1]) / 1000000000;
            decimal mbPerSecond = mbWritten / elapsedSeconds;
            
            log:printInfo(string `Progress: ${formatDecimal(mbWritten, 1)}MB written (${formatDecimal(progressPercent, 1)}%) - Speed: ${formatDecimal(mbPerSecond, 1)}MB/s`);
            nextLogThreshold += logIntervalBytes;
        }
    }
    
    // Close file
    error? closeResult = fileChannel.close();
    if closeResult is error {
        log:printWarn(string `Warning: Failed to close file properly: ${closeResult.message()}`);
    }
    
    // Final statistics
    time:Utc endTime = time:utcNow();
    decimal totalElapsedSeconds = <decimal>(endTime[0] - startTime[0]) + <decimal>(endTime[1] - startTime[1]) / 1000000000;
    decimal totalMB = <decimal>bytesWritten / <decimal>BYTES_PER_MB;
    decimal avgSpeed = totalMB / totalElapsedSeconds;
    
    log:printInfo(string `File creation completed: ${formatDecimal(totalMB, 1)}MB in ${formatDecimal(totalElapsedSeconds, 1)}s (avg: ${formatDecimal(avgSpeed, 1)}MB/s)`);
    
    return;
}

function generateChunk(int remainingBytes) returns byte[]|error {
    // Determine chunk size (max 1MB to avoid memory issues)
    int chunkSize = remainingBytes > BYTES_PER_MB ? BYTES_PER_MB : remainingBytes;
    
    // Create a text-based chunk with multiple lines
    string[] lines = [];
    int approxBytesPerLine = 100; // Approximate bytes per line
    int targetLines = chunkSize / approxBytesPerLine;
    
    int lineNumber = 1;
    while lines.length() < targetLines {
        // Generate varied content for each line
        int randomNum = check random:createIntInRange(1000, 9999);
        time:Utc currentTime = time:utcNow();
        string timeStr = time:utcToString(currentTime);
        
        string paddingData = createRepeatedString("x", 50);
        string line = string `Line ${lineNumber}: Timestamp=${timeStr}, Random=${randomNum}, Data=${paddingData}`;
        lines.push(line);
        lineNumber += 1;
    }
    
    string content = string:'join("\n", ...lines);
    content += "\n"; // Add final newline
    
    // Adjust content to match target chunk size more precisely
    if content.toBytes().length() < chunkSize {
        // Pad with additional characters if needed
        int padding = chunkSize - content.toBytes().length();
        content += createRepeatedString("=", padding);
    } else if content.toBytes().length() > chunkSize {
        // Trim if too large
        content = content.substring(0, chunkSize);
    }
    
    return content.toBytes();
}

function ensureDirectoryExists(string directoryPath) returns error? {
    boolean|error dirExists = file:test(directoryPath, file:EXISTS);
    if dirExists is error {
        return error(string `Failed to check if directory exists: ${dirExists.message()}`);
    }
    
    if !dirExists {
        log:printInfo(string `Creating directory: ${directoryPath}`);
        error? createResult = file:createDir(directoryPath, file:RECURSIVE);
        if createResult is error {
            return error(string `Failed to create directory: ${createResult.message()}`);
        }
    }
}

// Helper function to format decimal numbers
function formatDecimal(decimal value, int decimalPlaces) returns string {
    string valueStr = value.toString();
    int? dotIndex = valueStr.indexOf(".");
    
    if dotIndex is () {
        return valueStr + ".0";
    }
    
    int endIndex = dotIndex + decimalPlaces + 1;
    if endIndex >= valueStr.length() {
        return valueStr;
    }
    
    return valueStr.substring(0, endIndex);
}

// Helper function to create repeated strings
function createRepeatedString(string char, int count) returns string {
    string result = "";
    int i = 0;
    while i < count {
        result += char;
        i += 1;
    }
    return result;
}
