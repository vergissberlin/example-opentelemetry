package main

import (
	"context"
	"encoding/json"
	"log"
	"math/rand"
	"net/http"

	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
	"go.opentelemetry.io/otel/trace"
)

var tracer trace.Tracer

type Response struct {
	RandomValue int `json:"value"`
}

func newExporter() (sdktrace.SpanExporter, error) {
	return stdouttrace.New(stdouttrace.WithPrettyPrint())
}

func newTraceProvider(exp sdktrace.SpanExporter) *sdktrace.TracerProvider {
	// Ensure default SDK resources and the required service name are set.
	r, err := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceName("ExampleService"),
		),
	)

	if err != nil {
		panic(err)
	}

	return sdktrace.NewTracerProvider(
		sdktrace.WithBatcher(exp),
		sdktrace.WithResource(r),
	)
}

// Zufallswert-Endpunkt-Handler
func randomHandler(w http.ResponseWriter, r *http.Request) {
	_, span := tracer.Start(r.Context(), "GenerateRandomValue")
	defer span.End()

	randomValue := rand.Intn(145) // Zufallswert zwischen 0 und 144
	response := Response{RandomValue: randomValue}

	// Setzt die Header und kodiert die Antwort als JSON
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)

	// Füge zusätzlichen Kontext zum Span hinzu
	span.AddEvent("Generated random value", trace.WithAttributes())
}

func main() {
	ctx := context.Background()

	// Initialisiere den Exporter
	exp, err := newExporter()
	if err != nil {
		log.Fatalf("failed to initialize exporter: %v", err)
	}

	// Create a new tracer provider with a batch span processor and the given exporter.
	tp := newTraceProvider(exp)
	otel.SetTracerProvider(tp)

	// Finally, set the tracer that can be used for this package.
	tracer = tp.Tracer("thinkport.digital/go/dice")

	// Definiere den HTTP-Handler mit OpenTelemetry
	http.Handle("/dice", otelhttp.NewHandler(http.HandlerFunc(randomHandler), "RandomHandler"))

	// Starte den HTTP-Server auf Port 8080
	log.Println("Server läuft auf Port 8080")
	log.Fatal(http.ListenAndServe(":8080", nil))

	// Handle shutdown properly so nothing leaks.
	defer func() { _ = tp.Shutdown(ctx) }()

	otel.SetTracerProvider(tp)
}
