open MemcTypes
  
let string_of_error_response = function
    `Error -> "ERROR"
  | `Client_error (s) -> "CLIENT_ERROR " ^ s 
  | `Server_error (s) -> "SERVER_ERROR " ^ s

let string_of_storage_response _ = raise Exit

let empty_response = ""

let buffer_of_retrieval_item cas_unique item =
  let b = Buffer.create 16 in
    Buffer.add_string b ("VALUE " ^ item.key ^ " "
                         ^ (string_of_int item.flags) ^ " "
                         ^ (string_of_int item.bytes)
                         ^ (match cas_unique with
                                Some (cas) -> Int64.to_string cas
                              | None -> "")) ;
    Buffer.add_string b item.data ;
    b
      
let string_of_get_response lst =
  let b = Buffer.create 16 in
    List.iter (fun item ->
                 Buffer.add_buffer b (buffer_of_retrieval_item None item))
      lst ;
    Buffer.contents b

let string_of_gets_response lst =
  let b = Buffer.create 16 in
    List.iter (function (cas, item) ->
                 Buffer.add_buffer b (buffer_of_retrieval_item
                                        (Some cas)
                                        item))
      lst ;
    Buffer.contents b

let string_of_retrieval_response rr =
  (match rr with
       Empty -> empty_response
     | GetResponse (gr) -> string_of_get_response gr 
     | GetsResponse (gsr) -> string_of_gets_response gsr)
  ^ "END"
        
let string_of_storage_response = function
    `Stored -> "STORED"
  | `Not_stored -> "NOT_STORED"
  | `Exists -> "EXISTS"
  | `Not_found -> "NOT_FOUND"
      
let string_of_response = function
    ErrorResponse (er) -> (string_of_error_response er) ^ "\r\n"
  | StorageResponse (sr) -> (string_of_storage_response sr) ^ "\r\n"
  | RetrievalResponse (rr) -> (string_of_retrieval_response rr) ^ "\r\n"
