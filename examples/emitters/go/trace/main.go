package main

import (
	"context"
	"sync"
	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.24.0"
)

func main() {
	ctx := context.Background()

	// Create the exporter - let's use a stdout exporter
	traceExporter, err := stdouttrace.New(stdouttrace.WithPrettyPrint())
	if err != nil {
		panic(err)
	}

	// Create the resource to be traced
	res, err := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceName("MyService"),
			semconv.ServiceVersion("v0.0.1"),
		),
	)

	// Configure the trace provider
	traceProvider := trace.NewTracerProvider(
		trace.WithBatcher(traceExporter, trace.WithBatchTimeout(2*time.Second)),
		trace.WithResource(res),
	)
	defer func() { _ = traceProvider.Shutdown(ctx) }()
	otel.SetTracerProvider(traceProvider)
	var wg sync.WaitGroup
	wg.Add(2)
	go operationA(ctx, &wg)
	go operationB(ctx, &wg)
	wg.Wait()
}

func operationA(ctx context.Context, wg *sync.WaitGroup) {
	defer wg.Done()
	// Create & start the tracer
	tracer := otel.Tracer("MyService")
	_, span := tracer.Start(ctx, "operationA")
	span.SetAttributes(attribute.String("environment", "staging"))
	defer span.End()

	for i := 0; i < 5; i++ {
		// Add events
		span.AddEvent("iterate operationA")
		time.Sleep(1 * time.Second)
	}

}

func operationB(ctx context.Context, wg *sync.WaitGroup) {
	defer wg.Done()
	// Create & start the tracer
	tracer := otel.Tracer("MyService")
	_, span := tracer.Start(context.Background(), "operationB")
	span.SetAttributes(attribute.String("environment", "staging"))
	defer span.End()

	for i := 0; i < 5; i++ {
		// Add events
		span.AddEvent("iterate operationB")
		time.Sleep(2 * time.Second)
	}
}
