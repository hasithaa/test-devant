# Large File Generator

This Ballerina program generates large files using streaming to avoid memory issues. It's designed to create files up to several GB in size with configurable parameters and progress logging.

## Features

- **Streaming File Generation**: Uses streaming I/O to handle large files without consuming excessive memory
- **Configurable Size**: Set the target file size in GB (default: 4GB)
- **Progress Logging**: Logs progress at configurable intervals (default: every 50MB)
- **Multi-line Content**: Generates text files with multiple lines containing timestamps and random data
- **Performance Metrics**: Shows writing speed and elapsed time

## Configuration

You can configure the program by modifying `Config.toml`:

```toml
# File size in GB
fileSizeGB = 4

# Output directory
outputDirectory = "tmp"

# File name
fileName = "large_file.txt"

# Logging interval in MB
logIntervalMB = 50
```

## Usage

### Build and Run

```bash
# Build the project
bal build

# Run with default configuration
bal run

# Or run the compiled JAR
java -jar target/bin/myautomation.jar
```

### Command Line Configuration

You can also override configuration at runtime:

```bash
# Create a 2GB file with logging every 25MB
bal run -- -CfileSizeGB=2 -ClogIntervalMB=25

# Change output directory and filename
bal run -- -CoutputDirectory=/tmp/test -CfileName=test_file.txt
```

## Output

The program will:

1. Create the specified output directory if it doesn't exist
2. Generate a large file with the specified size
3. Log progress at the configured intervals
4. Display performance statistics upon completion

### Sample Output

```
2025-07-24T10:30:15.123Z [INFO] [myautomation] - Starting large file generation process...
2025-07-24T10:30:15.124Z [INFO] [myautomation] - Configuration: Size=4GB, LogInterval=50MB, Directory=tmp
2025-07-24T10:30:15.125Z [INFO] [myautomation] - Creating directory: tmp
2025-07-24T10:30:15.126Z [INFO] [myautomation] - Creating file: tmp/large_file.txt (4GB)
2025-07-24T10:30:20.250Z [INFO] [myautomation] - Progress: 50.0MB written (1.2%) - Speed: 10.0MB/s
2025-07-24T10:30:25.375Z [INFO] [myautomation] - Progress: 100.0MB written (2.4%) - Speed: 10.0MB/s
...
2025-07-24T10:37:15.500Z [INFO] [myautomation] - File creation completed: 4096.0MB in 420.0s (avg: 9.8MB/s)
2025-07-24T10:37:15.501Z [INFO] [myautomation] - File generation completed successfully!
```

## File Content

The generated file contains multiple lines with the following format:

```
Line 1: Timestamp=2025-07-24T10:30:15.123456789Z, Random=1234, Data=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Line 2: Timestamp=2025-07-24T10:30:15.123456790Z, Random=5678, Data=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
...
```

Each line includes:
- Sequential line numbers
- UTC timestamps
- Random numbers for variation
- Padding data to reach target size

## Performance Considerations

- The program writes in 1MB chunks to balance memory usage and I/O efficiency
- Progress is logged at configurable intervals to monitor long-running operations
- The actual file size may vary slightly due to line boundaries and content generation
- Writing speed depends on disk performance and system resources

## Error Handling

The program includes comprehensive error handling for:
- Directory creation failures
- File creation and writing errors
- Invalid configuration parameters
- System resource limitations

All errors are logged with detailed messages to help with troubleshooting.
