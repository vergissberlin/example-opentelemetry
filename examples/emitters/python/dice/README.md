# Example python implementation for OpenTelemtry


## Install deptendencies

```bash
pip install -r requirements.txt
opentelemetry-bootstrap -a install
```

## Run application

```bash
flask run -p 8080
```


### Configure python application

```bash
export OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true \
    opentelemetry-instrument \
    --traces_exporter console \
    --metrics_exporter console \
    --logs_exporter console \
    --service_name dice-server \
    flask run -p 8080
```
