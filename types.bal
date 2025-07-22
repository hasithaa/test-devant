
type SFTPConfig record {
    string vendorId;
    string host;
    int port;
    string username;
    string password;
};


## Vendor and VendorConfig records

type Vendor record {|
    # Vendor ID
    string id;
    # Vendor name
    string name;
    # Vendor contact details
    string email;
    # Vendor phone number
    string phone;
    # SFTP configuration for the vendor
    SFTPConfig sftpConfig;
|};

type VendorConfig record {|
    Vendor v1;
    Vendor v2;
    Vendor v3 = { id  : "v3", name : "Vendor 3", email : "vendor3@example.com", phone : "555-555-5555", sftpConfig : { vendorId : "v3", host : "sftp.example.com", port : 22, username : "user3", password : "pass3" } };
|};