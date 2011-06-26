open MemcTypes

val string_of_error_response : error_response -> string

val string_of_storage_response : storage_response -> string

val buffer_of_retrieval_item : int64 option -> retrieval_item -> Buffer.t

val string_of_get_response : retrieval_item list -> string

val string_of_gets_response : (int64 * retrieval_item) list -> string

val string_of_retrieval_response : retrieval_response -> string

val string_of_storage_response : storage_response -> string

val string_of_response : response -> string
  
