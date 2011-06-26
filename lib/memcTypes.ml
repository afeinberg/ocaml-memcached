type storage_command =
    [ `Set
    | `Add
    | `Replace
    | `Append
    | `Prepend
    ]

type storage_header = Store of storage_command | Cas of int64

type storage_packet = {
  key: string;
  flags: int;
  exptime: int64;
  bytes: int;
  noreply: bool;
}

type storage_request = storage_header * storage_packet

type retrieval_command =
    [ `Get
    | `Gets
    ]

type retrieval_request = retrieval_command * string list

type request = StorageRequest of storage_request | RetrievalRequest of retrieval_request
  
type error_response =
    [ `Error
    | `Client_error of string
    | `Server_error of string
    ]

type storage_response =
    [ `Stored
    | `Not_stored
    | `Exists
    | `Not_found
    ]

type retrieval_item = {
  key: string;
  flags: int;
  bytes: int;
  data: string;
}

type retrieval_response =
    Empty
  | GetResponse of (retrieval_item list)
  | GetsResponse of (int64 * retrieval_item) list

type response = ErrorResponse of error_response
                | StorageResponse of storage_response
                | RetrievalResponse of retrieval_response
                    
exception Invalid_command
exception Malformed_request of string
