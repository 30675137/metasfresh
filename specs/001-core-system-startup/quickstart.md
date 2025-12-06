# Quickstart Guide: Core System Startup Validation

## Overview

This guide provides instructions for setting up, running, and validating the core system startup validation feature. This feature ensures that all critical system components are properly initialized during application startup.

## Prerequisites

- Java 17 or higher
- Maven 3.8+
- PostgreSQL 15+ (for configuration storage)
- Docker (optional, for containerized deployment)
- Access to RabbitMQ (for message queue validation)

## Setup

1. **Clone the repository**:
   ```bash
   git checkout 001-core-system-startup
   ```

2. **Configure application properties**:
   Create `application.yml` in `src/main/resources`:
   ```yaml
   spring:
     datasource:
       url: jdbc:postgresql://localhost:5432/metasfresh
       username: metasfresh
       password: metasfresh
     rabbitmq:
       host: localhost
       port: 5672
       username: guest
       password: guest

   health:
     check:
       database:
         enabled: true
         timeoutMs: 5000
       filesystem:
         paths:
           - /opt/metasfresh/documentArchive
         writable: true
       external:
         services:
           - url: http://localhost:15672
             timeoutMs: 3000
   ```

3. **Build the module**:
   ```bash
   cd backend/de.metas.startup.validation
   mvn clean install
   ```

## Running the Application

### Development Mode

1. **Run with Maven**:
   ```bash
   mvn spring-boot:run
   ```

2. **Run with Java**:
   ```bash
   java -jar target/de.metas.startup.validation-1.0.0.jar
   ```

### Docker Mode

1. **Build Docker image**:
   ```bash
   docker build -t metasfresh-startup-validation .
   ```

2. **Run container**:
   ```bash
   docker run -p 8080:8080 metasfresh-startup-validation
   ```

## Validation Checks

### Startup Validation Process

During startup, the system performs the following validation checks in order:

1. **Configuration Validation**:
   - Validates required configuration properties
   - Checks file system path accessibility
   - Ensures all mandatory settings are present

2. **Database Connection**:
   - Tests database connectivity
   - Validates connection pool initialization
   - Checks schema version compatibility

3. **External Service Connectivity**:
   - Tests RabbitMQ connection
   - Validates external API endpoints
   - Ensures message queues are accessible

4. **Service Initialization**:
   - Verifies async work processors
   - Checks scheduler service status
   - Ensures all components are properly initialized

### Expected Startup Sequence

```
[INFO] Starting StartupValidationApplication...
[INFO] Validating configuration properties...
[INFO] Configuration validation completed successfully
[INFO] Initializing database connection pool...
[INFO] Database connection established (5 active connections)
[INFO] Validating filesystem access to /opt/metasfresh/documentArchive...
[INFO] Filesystem validation completed successfully
[INFO] Testing RabbitMQ connection...
[INFO] RabbitMQ connection successful
[INFO] Initializing async work processors...
[INFO] Async processors initialized and ready
[INFO] Starting embedded Tomcat server...
[INFO] Tomcat started on port(s): 8080
[INFO] Application startup completed in 45.2 seconds
```

## Health Check Endpoints

### Overall Health (`/api/health`)

```bash
curl -v http://localhost:8080/api/health
```

Expected response (200 OK):
```json
{
  "status": "UP",
  "components": {
    "database": {
      "status": "UP",
      "responseTimeMs": 15
    },
    "rabbitmq": {
      "status": "UP",
      "responseTimeMs": 25
    },
    "diskSpace": {
      "status": "UP",
      "responseTimeMs": 5
    }
  },
  "details": {
    "startupTimeMs": 45200,
    "timestamp": "2025-12-06T10:30:45.123Z"
  }
}
```

### Readiness Check (`/api/health/readiness`)

```bash
curl -v http://localhost:8080/api/health/readiness
```

Expected response (200 OK when ready):
```json
{
  "status": "UP",
  "details": {
    "message": "Application is ready to serve requests",
    "readySince": "2025-12-06T10:30:45.123Z"
  }
}
```

### Liveness Check (`/api/health/liveness`)

```bash
curl -v http://localhost:8080/api/health/liveness
```

Expected response (200 OK when alive):
```json
{
  "status": "UP",
  "details": {
    "message": "Application is alive"
  }
}
```

## Failure Scenarios

### Configuration Error

If a required configuration property is missing:
```
[ERROR] Missing required configuration property: spring.datasource.url
[ERROR] Application startup failed - terminating with exit code 1
```

Response from health endpoint (503 Service Unavailable):
```json
{
  "status": "DOWN",
  "components": {
    "configuration": {
      "status": "DOWN",
      "details": {
        "error": "Missing required configuration property: spring.datasource.url"
      }
    }
  }
}
```

### Database Connection Failure

If database connection fails:
```
[ERROR] Failed to establish database connection within 10 seconds
[ERROR] Application startup failed - terminating with exit code 1
```

Response from health endpoint (503 Service Unavailable):
```json
{
  "status": "DOWN",
  "components": {
    "database": {
      "status": "DOWN",
      "details": {
        "error": "Connection timed out"
      }
    }
  }
}
```

## Monitoring and Troubleshooting

### Startup Events Endpoint

Retrieve startup events for debugging:
```bash
curl http://localhost:8080/api/startup/events?limit=20
```

Sample response:
```json
[
  {
    "eventId": "evt-001",
    "eventType": "STARTING",
    "timestamp": "2025-12-06T10:30:00.000Z",
    "message": "Application startup initiated",
    "severity": "INFO",
    "details": {}
  },
  {
    "eventId": "evt-002",
    "eventType": "CONFIG_VALIDATION",
    "timestamp": "2025-12-06T10:30:01.234Z",
    "message": "Configuration validation completed successfully",
    "severity": "INFO",
    "details": {}
  }
]
```

### Log Analysis

Key log entries to monitor:
- `[INFO]` entries for successful validations
- `[WARN]` entries for non-critical issues
- `[ERROR]` entries for failures requiring attention

Log file location: `/var/log/metasfresh/startup-validation.log`

## Testing

### Unit Tests

Run unit tests:
```bash
mvn test
```

### Integration Tests

Run integration tests:
```bash
mvn verify
```

### Manual Validation

1. Start the application with valid configuration
2. Verify health endpoints return expected responses
3. Check startup logs for successful completion messages
4. Test failure scenarios by removing required configuration

## Common Issues and Solutions

### Issue: Application fails to start with configuration error

**Solution**: Check `application.yml` for missing required properties:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/metasfresh  # Required
    username: metasfresh                              # Required
    password: metasfresh                              # Required
```

### Issue: Database connection timeout

**Solution**: Verify database is running and accessible:
```bash
# Test database connectivity
telnet localhost 5432
# or
nc -zv localhost 5432
```

### Issue: Health endpoint returns DOWN status

**Solution**: Check the detailed error message in the response and logs:
```bash
curl http://localhost:8080/api/health | jq '.components'
```

## Next Steps

1. Implement additional validation rules as needed
2. Configure monitoring alerts for health check failures
3. Set up automated deployment with health check verification
4. Review and adjust timeout values based on environment