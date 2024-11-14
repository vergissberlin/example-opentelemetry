package main

import (
	"context"
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"time"

	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
	"go.opentelemetry.io/otel"

	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
	"go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
	"go.opentelemetry.io/otel/trace"
)

var tracer trace.Tracer

type Response struct {
	RandomValue int `json:"value"`
}

func newConsoleExporter() (sdktrace.SpanExporter, error) {
	return stdouttrace.New(stdouttrace.WithPrettyPrint())
}

func newOtlpHttpExporter(ctx context.Context) (sdktrace.SpanExporter, error) {
	otlpTraceExporter, err := otlptracegrpc.New(
		ctx,
		otlptracegrpc.WithEndpoint("localhost:4317"),
		otlptracegrpc.WithInsecure(),
	)
	if err != nil {
		return nil, err
	}
	return otlpTraceExporter, nil
}

func newOtlpGrpcExporter(ctx context.Context) (sdktrace.SpanExporter, error) {
	otlpTraceExporter, err := otlptracegrpc.New(
		ctx,
		otlptracegrpc.WithEndpoint("localhost:4317"),
		otlptracegrpc.WithInsecure(),
		otlptracegrpc.WithTimeout(10*time.Second),
	)
	if err != nil {
		return nil, err
	}
	return otlpTraceExporter, nil
}

func newTraceProvider(exp sdktrace.SpanExporter) *sdktrace.TracerProvider {
	// Ensure default SDK resources and the required service name are set.
	r, err := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.CodeFunction("main"),
			semconv.CodeFilepath("main.go"),
			semconv.CodeLineNumber(42),
			semconv.ServiceName("go-dice"),
			semconv.ServiceVersion("v1.0.0"),
			semconv.ServiceInstanceID("instance-1"),
			semconv.MessagingBatchMessageCount(10),
			semconv.ServerPort(8080),
			semconv.ServerAddress("localhost"),
		),
	)

	// Create a new trace provider with a batch span processor and the given exporter.
	if err != nil {
		panic(err)
	}

	// Create a new trace provider with a batch span processor and the given exporter.
	return sdktrace.NewTracerProvider(
		sdktrace.WithBatcher(exp),
		sdktrace.WithResource(r),
	)
}

func randomHandler(w http.ResponseWriter, r *http.Request) {
	_, span := tracer.Start(r.Context(), "Start generate random value")

	randomValue := rand.Intn(145) // Create a random number between 0 and 144
	response := Response{RandomValue: randomValue}

	// Set the response header to application/json
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)

	// Add an event to the span
	span.AddEvent("Generated random value event", trace.WithAttributes())

	// End the span
	span.End()
}

func main() {
	// Initialize context to be used in subroutines
	ctx := context.Background()

	// Initialize exporter
	exp, err := newOtlpGrpcExporter(ctx)
	if err != nil {
		log.Fatalf("failed to initialize exporter: %v", err)
	}

	// Create a new trace provider with the exporter
	tp := newTraceProvider(exp)
	otel.SetTracerProvider(tp)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(
		propagation.Baggage{},
		propagation.TraceContext{},
	))

	// Create a new tracer
	tracer = tp.Tracer("thinkport.digital/go/dice")

	// Define a new handler for the root path
	http.Handle(
		"/",
		otelhttp.NewHandler(
			http.HandlerFunc(randomHandler),
			"RandomHandler",
		),
	)

	// Start the server on port 8080
	log.Println("Server läuft auf http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))

	// Handle shutdown properly so nothing leaks.
	defer func() { _ = tp.Shutdown(ctx) }()
}
