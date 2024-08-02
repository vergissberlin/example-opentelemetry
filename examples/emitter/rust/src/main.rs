use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Method, Request, Response, Server, StatusCode};
use opentelemetry::trace::{SpanKind, Status};
use opentelemetry::{global, trace::Tracer};
use opentelemetry_sdk::propagation::TraceContextPropagator;
use opentelemetry_sdk::trace::TracerProvider;
use opentelemetry_stdout::SpanExporter;
use rand::Rng;
use std::{convert::Infallible, net::SocketAddr};

async fn handle(req: Request<Body>) -> Result<Response<Body>, Infallible> {
    let mut response = Response::new(Body::empty());

    let tracer = global::tracer("dice_server");

    let span_builder = tracer
        .span_builder(format!("{} {}", req.method(), req.uri().path()))
        .with_kind(SpanKind::Server);

    match (req.method(), req.uri().path()) {
        (&Method::GET, "/rolldice") => {
            let random_number = rand::thread_rng().gen_range(1..7);
            *response.body_mut() = Body::from(random_number.to_string());
        }
        _ => {
            *response.status_mut() = StatusCode::NOT_FOUND;
            span_builder
                .with_status(Status::error("Not found"))
                .start(&tracer);
        }
    };

    Ok(response)
}

fn init_tracer() {
    global::set_text_map_propagator(TraceContextPropagator::new());
    let provider = TracerProvider::builder()
        .with_simple_exporter(SpanExporter::default())
        .build();
    global::set_tracer_provider(provider);
}

#[tokio::main]
async fn main() {
    init_tracer();
    let addr = SocketAddr::from(([127, 0, 0, 1], 8080));

    let make_svc = make_service_fn(|_conn| async { Ok::<_, Infallible>(service_fn(handle)) });

    let server = Server::bind(&addr).serve(make_svc);

    println!("Listening on {addr}");
    if let Err(e) = server.await {
        eprintln!("server error: {e}");
    }
}
