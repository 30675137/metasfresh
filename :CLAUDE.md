# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

metasfresh is an Open Source ERP system with a 3-tier architecture:
- Backend: Java-based services using Spring Boot
- Frontend: React-based web UI
- Database: PostgreSQL

This is a Maven monorepo containing multiple modules organized into several main directories:

### Key Directories

- **backend/**: Main Java backend services and modules (Maven multi-module project)
- **frontend/**: React-based web user interface
- **misc/**: Parent POM, dev-support tools, and shared libraries
- **distribution/**: Kubernetes and deployment configurations
- **docker-builds/**: Dockerfiles and container configurations
- **e2e/**: End-to-end testing (K6 performance tests, frontend tests)

## Build System

### Maven Structure

The project uses Maven with a parent POM structure:
- Root POM: `backend/pom.xml` (de.metas.parent)
- Parent POM: `misc/parent-pom/pom.xml` (de.metas.parent.general)

### Key Build Commands

```bash
# Build entire backend
mvn clean install

# Build with skipping tests
mvn clean install -DskipTests

# Build specific module
cd backend/de.metas.business
mvn clean install

# Build frontend
cd frontend
npm install
npm run build
```

### Build Profiles

The backend POM includes several source directory profiles that activate automatically:
- `add-source-java-gen`: For `src/main/java-gen` directories
- `add-source-java-xjc`: For `src/main/java-xjc` directories
- `add-source-java-legacy`: For `src/main/java-legacy` directories

## Technology Stack

### Backend Technologies
- **Framework**: Spring Boot 2.4.3, Spring 5.3.4
- **Database**: PostgreSQL 42.3.3
- **Build Tool**: Maven
- **API Documentation**: SpringFox Swagger
- **Testing**: JUnit 5, Cucumber for BDD
- **Reporting**: JasperReports
- **Excel/Word Processing**: Apache POI 4.1.2
- **Barcode/QR Code**: ZXing 2.3.0
- **Search**: Apache Lucene 8.6.2

### Frontend Technologies
- **Framework**: React with Redux
- **Build Tool**: Webpack
- **Package Manager**: npm

## Module Organization

The backend contains 70+ modules organized by business domain:

### Core Modules
- `de.metas.adempiere.adempiere`: Core ADempiere/ERP functionality
- `de.metas.business`: Core business logic
- `de.metas.ui.web.base`: Web UI backend services

### Business Domain Modules
- `de.metas.material`: Material management and planning
- `de.metas.manufacturing`: Manufacturing and production
- `de.metas.handlingunits`: Handling units and warehouse management
- `de.metas.banking`, `de.metas.payment.*`: Financial modules
- `de.metas.contracts`: Contract management
- `de.metas.invoice_gateway.*`: Invoice processing
- `de.metas.shipper.gateway.*`: Shipping integration
- `de.metas.externalsystem`: External system integrations
- `de.metas.elasticsearch`: Search capabilities

### REST API Modules
- `de.metas.business.rest-api`: API definitions
- `de.metas.business.rest-api-impl`: API implementations
- `de.metas.manufacturing.rest-api`
- `de.metas.picking.rest-api`
- `de.metas.distribution.rest-api`

### Mobile/Modern UI Modules
- `de.metas.handlingunits.mobileui`: Mobile UI for handling units
- `de.metas.inventory.mobileui`: Mobile inventory management
- `de.metas.picking.rest-api`: Picking operations API
- `de.metas.pos.*`: Point of Sale system

### Reporting and Printing
- `de.metas.printing.*`: Document printing infrastructure
- `de.metas.report`: Reporting framework

### Migration and Deployment
- `de.metas.migration`: Database migration tools
- `metasfresh-dist`: Distribution assembly
- `metasfresh-webui-api`: Web UI API server

## Testing

### Unit and Integration Tests
Tests are colocated with source code:
- Unit tests: `src/test/java`
- Uses JUnit 5 (Jupiter)

### Cucumber BDD Tests
Dedicated module: `backend/de.metas.cucumber`
- Feature files: `src/test/resources/de/metas/cucumber/features`
- Step definitions: `src/test/java/de/metas/cucumber/stepdefs`
- Run with: `mvn test -Dtest=CucumberLifeCycleSupportTest`

### Testing Infrastructure
- **End-to-end**: K6 performance tests in `e2e/perf/k6/`
- **Frontend**: Test setups in `e2e/frontend-webui/`

## Database

### Migrations
Database migrations use the custom migration framework in `de.metas.migration`:
- Migration scripts in `src/main/sql/postgresql/system/` within each module
- Version tracking in `ad_migrationscript` table

### Schema Generation
Some modules use generated model classes:
- Generated code in `src/main/java-gen/` directories
- Generation triggered automatically during build

## Development Workflow

### Common Development Tasks

```bash
# 1. Full build
mvn clean install

# 2. Build specific module and dependencies
mvn clean install -pl de.metas.business -am

# 3. Run tests for specific module
cd backend/de.metas.business
mvn test

# 4. Build frontend
cd frontend
npm install && npm run build

# 5. Build Docker images
cd docker-builds
./build.sh
```

### Git Workflow
- Main development branch: `new_dawn_uat` (as per git status)
- Fork from `master` branch for contributions
- Use git sparse-checkout for partial repository checkouts

### Environment Variables
Build system uses these environment variables:
- `BUILD_NUMBER`: CI build number (set to "LOCAL-BUILD" if not provided)
- `MF_UPSTREAM_BRANCH`: Upstream branch name

## Docker Support

### Docker Build System
Located in `docker-builds/`:
- Separate Dockerfiles for each component (backend, frontend, database, etc.)
- Multi-stage builds for optimization
- docker-compose configurations in `docker-builds/compose/`

### Key Docker Images
- Backend API and App servers
- PostgreSQL database with migrations
- React frontend
- Apache Camel integration services
- Mobile UI components

## API Design

### REST API Conventions
- API interfaces in `*.rest-api` modules
- Implementations in `*.rest-api-impl` modules
- Swagger documentation auto-generated
- JSON-based request/response format

### Key API Domains
- Order candidates and sales orders
- Material management
- Manufacturing and production
- Inventory and warehousing
- Pricing and product data

## Code Generation

### Model Classes
- Database schema generates Java model classes
- Located in `src/main/java-gen/` directories
- Auto-detected via Maven profiles

### XSD to Java
- Some modules use JAXB/XJC for XML schema compilation
- Generated code in `src/main/java-xjc/` directories

## License and Legal

All source code files must include GPL v2 license headers. The license-maven-plugin automatically adds headers during the build process.
