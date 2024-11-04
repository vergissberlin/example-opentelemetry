# Propagator 

… with a Flutter frontend and a go backend.


## Usage

1. Generate the code
    ```bash
    protoc --go_out=. --go-grpc_out=. propagator_backend.proto
    protoc --go_out=. --go_opt=paths=source_relative 
    ```

2. Run the server
    ```bash
    go run server.go
    ```
