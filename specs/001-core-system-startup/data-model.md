# Data Model: Core System Startup Validation

## Entities

### SystemConfiguration

Represents system-wide configuration properties that are validated during startup.

**Attributes:**
- configKey (String): Unique identifier for the configuration property
- configValue (String): The value of the configuration property
- description (String): Human-readable description of the configuration
- isRequired (Boolean): Whether this configuration is mandatory for startup
- validationPattern (String): Optional regex pattern for value validation
- lastValidatedAt (Timestamp): When this configuration was last validated
- validationStatus (Enum: PENDING, VALID, INVALID): Current validation status
- validationMessage (String): Error message if validation failed

### HealthCheckResult

Represents the result of individual health checks performed during startup.

**Attributes:**
- checkId (String): Unique identifier for the health check
- componentName (String): Name of the component being checked
- checkType (Enum: DATABASE, FILESYSTEM, NETWORK, MEMORY, CUSTOM): Type of health check
- status (Enum: UP, DOWN, UNKNOWN): Current status of the component
- responseTimeMs (Long): Time taken to perform the check in milliseconds
- details (JSON): Additional details about the check result
- checkedAt (Timestamp): When the check was performed
- failureReason (String): Reason for failure if status is DOWN

### StartupEvent

Represents significant events that occur during the application startup process.

**Attributes:**
- eventId (String): Unique identifier for the event
- eventType (Enum: STARTING, CONFIG_VALIDATION, DB_CONNECTING, DB_MIGRATING, SERVICE_INITIALIZING, READY, ERROR): Type of startup event
- timestamp (Timestamp): When the event occurred
- message (String): Human-readable description of the event
- severity (Enum: INFO, WARN, ERROR): Severity level of the event
- details (JSON): Additional structured data about the event
- component (String): Which component generated the event

### ValidationRule

Represents validation rules applied to configuration properties or system resources.

**Attributes:**
- ruleId (String): Unique identifier for the validation rule
- ruleName (String): Human-readable name of the rule
- ruleType (Enum: CONFIG, FILESYSTEM, NETWORK, CUSTOM): Type of validation rule
- ruleExpression (String): Expression or pattern used for validation
- errorMessage (String): Message to display when validation fails
- isActive (Boolean): Whether the rule is currently active
- createdAt (Timestamp): When the rule was created
- createdBy (String): Who created the rule

## Relationships

1. **SystemConfiguration** ← → **ValidationRule** (Many-to-Many)
   - Configurations can have multiple validation rules
   - Validation rules can apply to multiple configurations

2. **StartupEvent** → **HealthCheckResult** (One-to-Many)
   - Each startup event can have multiple associated health check results
   - Health check results are associated with specific startup events

## Validation Rules

### SystemConfiguration Validation Rules:
- configKey must be non-null and unique
- isRequired configurations must have non-null configValue
- configValue must match validationPattern if specified
- lastValidatedAt must be updated whenever validation occurs

### HealthCheckResult Validation Rules:
- checkId must be non-null
- status must be one of the defined enum values
- responseTimeMs must be non-negative
- checkedAt must not be in the future

### StartupEvent Validation Rules:
- eventType must be one of the defined enum values
- timestamp must not be in the future
- severity must be one of the defined enum values

### ValidationRule Validation Rules:
- ruleId must be non-null and unique
- ruleType must be one of the defined enum values
- isActive must be a valid boolean value

## State Transitions

### HealthCheckResult Status Transitions:
- UNKNOWN → UP (when health check passes)
- UNKNOWN → DOWN (when health check fails)
- UP → DOWN (when previously healthy component becomes unhealthy)
- DOWN → UP (when previously unhealthy component becomes healthy)

### StartupEvent Type Transitions:
The startup process follows a linear progression:
1. STARTING → CONFIG_VALIDATION
2. CONFIG_VALIDATION → DB_CONNECTING
3. DB_CONNECTING → DB_MIGRATING
4. DB_MIGRATING → SERVICE_INITIALIZING
5. SERVICE_INITIALIZING → READY (success path)
6. Any state → ERROR (failure path)