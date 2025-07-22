
type SFTPConfig record {
    string vendorId;
    string host;
    int port;
    string username;
    string password;
};


type Vendor record {|
    string id;
    string name;
    string email;
    string phone;
    SFTPConfig sftpConfig;
|};

type VendorConfig record {|
    Vendor v1;
    Vendor v2;
|};