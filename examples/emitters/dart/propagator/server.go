package main

import (
    "context"
    "fmt"
    "log"
    "net"
    pb "vergissberlin/example-opentelemetry/emitter/propagator/propagator"

    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
    "go.opentelemetry.io/otel/sdk/trace"
    "go.opentelemetry.io/otel/trace"
    "google.golang.org/grpc"
)


// Server implementiert den gRPC-Server
type server struct {
    pb.UnimplementedMyGrpcServiceServer
    tracer trace.Tracer
}

// MyRpcMethod ist die implementierte RPC-Methode
func (s *server) MyRpcMethod(ctx context.Context, req *pb.MyRequest) (*pb.MyResponse, error) {
    // Starte einen neuen Span für die Trace-Verfolgung
    ctx, span := s.tracer.Start(ctx, "MyRpcMethod")
    defer span.End()

    log.Printf("Received request with name: %s", req.Name)

    // Erstelle die Antwort
    message := fmt.Sprintf("Hello %s", req.Name)
    response := &pb.MyResponse{Message: message}
    return response, nil
}

// SetupOpenTelemetry konfiguriert OpenTelemetry
func SetupOpenTelemetry() (*trace.TracerProvider, error) {
    exporter, err := otlptracehttp.New(context.Background())
    if err != nil {
        return nil, err
    }

    provider := trace.NewTracerProvider(
        trace.WithBatcher(exporter),
    )
    otel.SetTracerProvider(provider)
    return provider, nil
}

func main() {
    // Set up OpenTelemetry
    tracerProvider, err := SetupOpenTelemetry()
    if err != nil {
        log.Fatalf("failed to set up OpenTelemetry: %v", err)
    }
    defer func() {
        _ = tracerProvider.Shutdown(context.Background())
    }()

    // Erstelle einen gRPC-Server
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    s := grpc.NewServer()

    // Registriere den Server mit dem Tracer
    tracer := otel.Tracer("my-grpc-service")
    pb.RegisterMyGrpcServiceServer(s, &server{tracer: tracer})

    log.Println("gRPC server is running on port 50051...")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}