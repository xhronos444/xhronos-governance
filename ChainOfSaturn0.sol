pragma solidity ^0.8.20;

contract ChainOfSaturn0 {

    address public architect;

    struct CanonEntry {
        uint256 id;
        string  name;
        string  entryType;
        string  layer;
        bytes32 contentHash;
        string  ipfsCid;
        string  arweaveTxId;
        address author;
        uint256 timestamp;
        bool    exists;
    }

    uint256 public entryCount;

    mapping(uint256 => CanonEntry) private entries;
    mapping(bytes32 => bool)       private hashRegistered;
    mapping(string  => bool)       private cidRegistered;
    mapping(string  => bool)       private arweaveRegistered;

    event GenesisAnchored(
        bytes32 indexed contentHash,
        string          ipfsCid,
        string          arweaveTxId,
        address indexed author
    );

    event CanonAppended(
        uint256 indexed id,
        bytes32 indexed contentHash,
        string          ipfsCid,
        string          arweaveTxId,
        address indexed author
    );

    modifier onlyArchitect() {
        require(msg.sender == architect, "NOT_ARCHITECT");
        _;
    }

    constructor() {
        architect = msg.sender;
    }

    function anchorGenesis(
        bytes32 contentHash,
        string calldata ipfsCid,
        string calldata arweaveTxId
    ) external onlyArchitect {
        require(entryCount == 0,                 "GENESIS_ALREADY_ANCHORED");
        require(contentHash != bytes32(0),       "INVALID_HASH");
        require(bytes(ipfsCid).length > 0,       "INVALID_CID");
        require(bytes(arweaveTxId).length > 0,   "INVALID_ARWEAVE_ID");
        require(!arweaveRegistered[arweaveTxId], "DUPLICATE_ARWEAVE_ID");

        hashRegistered[contentHash]    = true;
        cidRegistered[ipfsCid]         = true;
        arweaveRegistered[arweaveTxId] = true;

        entries[0] = CanonEntry({
            id:          0,
            name:        unicode"XENESYS \u2014 BLOCK 0",
            entryType:   "Genesis",
            layer:       "XENESYS",
            contentHash: contentHash,
            ipfsCid:     ipfsCid,
            arweaveTxId: arweaveTxId,
            author:      msg.sender,
            timestamp:   block.timestamp,
            exists:      true
        });

        entryCount = 1;

        emit GenesisAnchored(contentHash, ipfsCid, arweaveTxId, msg.sender);
    }

    function appendCanon(
        string calldata name,
        string calldata entryType,
        string calldata layer,
        bytes32         contentHash,
        string calldata ipfsCid,
        string calldata arweaveTxId
    ) external onlyArchitect {
        require(entryCount > 0,                  "GENESIS_NOT_ANCHORED");
        require(bytes(name).length > 0,          "INVALID_NAME");
        require(bytes(entryType).length > 0,     "INVALID_TYPE");
        require(bytes(layer).length > 0,         "INVALID_LAYER");
        require(contentHash != bytes32(0),       "INVALID_HASH");
        require(bytes(ipfsCid).length > 0,       "INVALID_CID");
        require(bytes(arweaveTxId).length > 0,   "INVALID_ARWEAVE_ID");
        require(!hashRegistered[contentHash],    "DUPLICATE_HASH");
        require(!cidRegistered[ipfsCid],         "DUPLICATE_CID");
        require(!arweaveRegistered[arweaveTxId], "DUPLICATE_ARWEAVE_ID");

        uint256 id = entryCount;

        hashRegistered[contentHash]    = true;
        cidRegistered[ipfsCid]         = true;
        arweaveRegistered[arweaveTxId] = true;

        entries[id] = CanonEntry({
            id:          id,
            name:        name,
            entryType:   entryType,
            layer:       layer,
            contentHash: contentHash,
            ipfsCid:     ipfsCid,
            arweaveTxId: arweaveTxId,
            author:      msg.sender,
            timestamp:   block.timestamp,
            exists:      true
        });

        entryCount++;

        emit CanonAppended(id, contentHash, ipfsCid, arweaveTxId, msg.sender);
    }

    function getEntry(uint256 id) external view returns (CanonEntry memory) {
        require(entries[id].exists, "NOT_FOUND");
        return entries[id];
    }

    function isHashRegistered(bytes32 contentHash) external view returns (bool) {
        return hashRegistered[contentHash];
    }

    function isCidRegistered(string calldata ipfsCid) external view returns (bool) {
        return cidRegistered[ipfsCid];
    }

    function isArweaveRegistered(string calldata arweaveTxId) external view returns (bool) {
        return arweaveRegistered[arweaveTxId];
    }
}
