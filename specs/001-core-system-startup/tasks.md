# Tasks: Core System Startup Validation

**Input**: Design documents from `/specs/001-core-system-startup/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests will be included for critical components to ensure 80%+ test coverage as required by the project constitution.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Web app**: `backend/src/`, `frontend/src/`
- For this feature: `backend/de.metas.startup.validation/src/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan in backend/de.metas.startup.validation/
- [ ] T002 Initialize Maven project with Spring Boot 3.x dependencies in backend/de.metas.startup.validation/pom.xml
- [ ] T003 [P] Configure code formatting and linting tools in backend/de.metas.startup.validation/
- [ ] T004 [P] Setup test framework (JUnit 5, Testcontainers) in backend/de.metas.startup.validation/pom.xml

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T005 Setup database configuration and connection properties in backend/de.metas.startup.validation/src/main/resources/application.yml
- [ ] T006 [P] Implement base exception handling and logging infrastructure in backend/de.metas.startup.validation/src/main/java/de/metas/startup/exception/
- [ ] T007 [P] Setup API routing and middleware structure in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/
- [ ] T008 Create base models/entities that all stories depend on in backend/de.metas.startup.validation/src/main/java/de/metas/startup/model/
- [ ] T009 Configure error handling and logging infrastructure in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/LoggingConfiguration.java
- [ ] T010 Setup environment configuration management in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - System Administrator Verifies Core Services Startup (Priority: P1) 🎯 MVP

**Goal**: Verify that all core backend services initialize properly during startup with health check endpoints

**Independent Test**: Start the application and verify that health endpoints return proper status codes and that application server logs show successful initialization of core services

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T011 [P] [US1] Contract test for overall health endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/health/HealthEndpointContractTest.java
- [ ] T012 [P] [US1] Integration test for core service initialization in backend/de.metas.startup.validation/src/test/java/de/metas/startup/StartupIntegrationTest.java

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create HealthStatus model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/HealthStatus.java
- [ ] T014 [P] [US1] Create ComponentHealth model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/ComponentHealth.java
- [ ] T015 [US1] Implement HealthCheckService in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/HealthCheckService.java (depends on T013, T014)
- [ ] T016 [US1] Implement HealthCheckController in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/HealthCheckController.java
- [ ] T017 [P] [US1] Implement core service health indicator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/CoreServiceHealthIndicator.java
- [ ] T018 [US1] Add validation and error handling for health checks in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/
- [ ] T019 [US1] Add logging for health check operations in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - DevOps Engineer Verifies Database Connectivity (Priority: P1)

**Goal**: Validate that the platform can establish and maintain database connections during startup

**Independent Test**: Start the application with different database configurations and verify connection pool status and health check responses

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T020 [P] [US2] Contract test for database health endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/health/DatabaseHealthContractTest.java
- [ ] T021 [P] [US2] Integration test for database connection validation in backend/de.metas.startup.validation/src/test/java/de/metas/startup/validation/DatabaseConnectionValidationTest.java

### Implementation for User Story 2

- [ ] T022 [P] [US2] Create DatabaseConnectionValidator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/DatabaseConnectionValidator.java
- [ ] T023 [US2] Implement database health indicator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/DatabaseHealthIndicator.java
- [ ] T024 [US2] Add database connection validation to startup process in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/StartupValidator.java
- [ ] T025 [US2] Add timeout controls for database connections in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/DatabaseConfiguration.java
- [ ] T026 [US2] Add logging for database connection events in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - System Validates Configuration and Environment Variables (Priority: P2)

**Goal**: Validate all required configuration parameters during startup to detect missing or invalid configurations immediately

**Independent Test**: Start the application with various configuration scenarios (missing properties, invalid paths) and verify validation messages in startup logs

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T027 [P] [US3] Contract test for configuration validation in backend/de.metas.startup.validation/src/test/java/de/metas/startup/validation/ConfigurationValidationContractTest.java
- [ ] T028 [P] [US3] Integration test for filesystem access validation in backend/de.metas.startup.validation/src/test/java/de/metas/startup/validation/DirectoryAccessValidationTest.java

### Implementation for User Story 3

- [ ] T029 [P] [US3] Create ConfigurationValidator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/ConfigurationValidator.java
- [ ] T030 [P] [US3] Create DirectoryAccessValidator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/DirectoryAccessValidator.java
- [ ] T031 [P] [US3] Create SystemConfiguration model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/model/SystemConfiguration.java
- [ ] T032 [P] [US3] Create ValidationRule model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/model/ValidationRule.java
- [ ] T033 [US3] Implement configuration validation during startup in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/StartupValidator.java
- [ ] T034 [US3] Add filesystem path validation with Files.isWritable() in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/DirectoryAccessValidator.java
- [ ] T035 [US3] Add centralized configuration management support in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/

**Checkpoint**: At this point, User Stories 1, 2 AND 3 should all work independently

---

## Phase 6: User Story 4 - API Gateway and WebUI Services Become Available (Priority: P2)

**Goal**: Verify that platform REST APIs are accessible after startup with proper health check endpoints

**Independent Test**: Make HTTP requests to health endpoints and verify response status codes and response times

### Tests for User Story 4 (OPTIONAL - only if tests requested) ⚠️

- [ ] T036 [P] [US4] Contract test for readiness endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/health/ReadinessEndpointContractTest.java
- [ ] T037 [P] [US4] Contract test for liveness endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/health/LivenessEndpointContractTest.java

### Implementation for User Story 4

- [ ] T038 [P] [US4] Implement readiness health endpoint in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/ReadinessHealthIndicator.java
- [ ] T039 [P] [US4] Implement liveness health endpoint in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/LivenessHealthIndicator.java
- [ ] T040 [US4] Add response time monitoring to health checks in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/
- [ ] T041 [US4] Add timeout controls for health endpoints in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/HealthConfiguration.java
- [ ] T042 [US4] Implement OpenAPI documentation for health endpoints in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/OpenApiConfiguration.java

**Checkpoint**: At this point, User Stories 1, 2, 3 AND 4 should all work independently

---

## Phase 7: User Story 5 - Background Processing and Queue Services Initialize (Priority: P3)

**Goal**: Validate that background job processors and message queues are operational during startup

**Independent Test**: Enqueue test jobs and verify they are picked up and processed, checking queue depths and processor states

### Tests for User Story 5 (OPTIONAL - only if tests requested) ⚠️

- [ ] T043 [P] [US5] Integration test for async processor initialization in backend/de.metas.startup.validation/src/test/java/de/metas/startup/validation/AsyncProcessorValidationTest.java
- [ ] T044 [P] [US5] Integration test for scheduler service validation in backend/de.metas.startup.validation/src/test/java/de/metas/startup/validation/SchedulerValidationTest.java

### Implementation for User Story 5

- [ ] T045 [P] [US5] Create async service health indicator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/AsyncServiceHealthIndicator.java
- [ ] T046 [P] [US5] Create scheduler health indicator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/SchedulerHealthIndicator.java
- [ ] T047 [US5] Implement background service validation in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/BackgroundServiceValidator.java
- [ ] T048 [US5] Add RabbitMQ connection validation in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/ExternalServiceValidator.java
- [ ] T049 [US5] Add logging for background service status in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/

**Checkpoint**: At this point, all user stories should be independently functional

---

## Phase 8: User Story 6 - Monitor and Validate All Critical Health Check Endpoints (Priority: P1)

**Goal**: Provide comprehensive health check endpoints that validate all critical system components for monitoring systems

**Independent Test**: Poll health endpoints and assert JSON responses, requiring no UI interaction

### Tests for User Story 6 (OPTIONAL - only if tests requested) ⚠️

- [ ] T050 [P] [US6] Contract test for comprehensive health endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/health/ComprehensiveHealthContractTest.java
- [ ] T051 [P] [US6] Integration test for metrics endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/monitoring/MetricsIntegrationTest.java

### Implementation for User Story 6

- [ ] T052 [P] [US6] Create metrics collection service in backend/de.metas.startup.validation/src/main/java/de/metas/startup/monitoring/StartupMetrics.java
- [ ] T053 [P] [US6] Create startup event logger in backend/de.metas.startup.validation/src/main/java/de/metas/startup/monitoring/StartupEventLogger.java
- [ ] T054 [P] [US6] Create StartupEvent model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/model/StartupEvent.java
- [ ] T055 [US6] Implement comprehensive health indicator aggregator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/ComprehensiveHealthIndicator.java
- [ ] T056 [US6] Add structured logging with SLF4J in backend/de.metas.startup.validation/src/main/java/de/metas/startup/monitoring/
- [ ] T057 [US6] Implement startup events endpoint in backend/de.metas.startup.validation/src/main/java/de/metas/startup/monitoring/StartupEventController.java
- [ ] T058 [US6] Add metrics endpoint integration with Micrometer in backend/de.metas.startup.validation/src/main/java/de/metas/startup/config/MetricsConfiguration.java

**Checkpoint**: All user stories should now be independently functional

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T059 [P] Documentation updates in docs/ and README files
- [ ] T060 Code cleanup and refactoring across all modules
- [ ] T061 Performance optimization across all stories
- [ ] T062 [P] Additional unit tests to reach 80%+ coverage in backend/de.metas.startup.validation/src/test/java/
- [ ] T063 Security hardening for health endpoints
- [ ] T064 Run quickstart.md validation and update if needed
- [ ] T065 [P] Add integration tests for failure scenarios in backend/de.metas.startup.validation/src/test/java/integration/
- [ ] T066 Final validation of all success criteria from spec.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 6 (P1)**: Can start after Foundational (Phase 2) - Integrates with US1, US2, US4
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 4 (P2)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 5 (P3)**: Can start after Foundational (Phase 2) - No dependencies on other stories

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Contract test for overall health endpoint in backend/de.metas.startup.validation/src/test/java/de/metas/startup/health/HealthEndpointContractTest.java"
Task: "Integration test for core service initialization in backend/de.metas.startup.validation/src/test/java/de/metas/startup/StartupIntegrationTest.java"

# Launch all models for User Story 1 together:
Task: "Create HealthStatus model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/HealthStatus.java"
Task: "Create ComponentHealth model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/health/ComponentHealth.java"
```

---

## Parallel Example: User Story 3

```bash
# Launch all models for User Story 3 together:
Task: "Create ConfigurationValidator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/ConfigurationValidator.java"
Task: "Create DirectoryAccessValidator in backend/de.metas.startup.validation/src/main/java/de/metas/startup/validation/DirectoryAccessValidator.java"
Task: "Create SystemConfiguration model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/model/SystemConfiguration.java"
Task: "Create ValidationRule model in backend/de.metas.startup.validation/src/main/java/de/metas/startup/model/ValidationRule.java"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 6 → Test independently → Deploy/Demo
5. Add User Story 3 → Test independently → Deploy/Demo
6. Add User Story 4 → Test independently → Deploy/Demo
7. Add User Story 5 → Test independently → Deploy/Demo
8. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 + User Story 2
   - Developer B: User Story 6 + User Story 4
   - Developer C: User Story 3 + User Story 5
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence