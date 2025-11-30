-- Go project templates
local M = {}

-- Web service template
M.web_service = [[package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "ok",
			"message": "Service is healthy",
		})
	})

	// API routes
	api := r.Group("/api/v1")
	{
		api.GET("/", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"message": "Welcome to %s API",
			})
		})
	}

	log.Printf("Server starting on :8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
]]

-- CLI application template
M.cli_app = [[package main

import (
	"flag"
	"fmt"
	"log"
	"os"
)

func main() {
	// Define flags
	var (
		name    = flag.String("name", "", "Your name")
		verbose = flag.Bool("v", false, "Verbose output")
		help    = flag.Bool("h", false, "Show this help message")
	)

	flag.Parse()

	if *help {
		fmt.Println("Usage: %s [options]", os.Args[0])
		fmt.Println("Options:")
		flag.PrintDefaults()
		return
	}

	if *verbose {
		log.SetFlags(log.LstdFlags | log.Lshortfile)
	}

	if *name != "" {
		fmt.Printf("Hello, %%s!\n", *name)
	} else {
		fmt.Println("Hello, World!")
	}
}
]]

-- Library template
M.library = [[package %s

// Package %s provides utilities for...
package %s

// Example structure
type %s struct {
	ID   string
	Name string
}

// New creates a new instance of %s
func New(id, name string) *%s {
	return &%s{
		ID:   id,
		Name: name,
	}
}

// String returns a string representation of %s
func (s *%s) String() string {
	return fmt.Sprintf("%%s{ID: %%s, Name: %%s}", s.Name, s.ID, s.Name)
}

// Validate checks if the struct fields are valid
func (s *%s) Validate() error {
	if s.ID == "" {
		return fmt.Errorf("ID cannot be empty")
	}
	if s.Name == "" {
		return fmt.Errorf("Name cannot be empty")
	}
	return nil
}
]]

-- Test template
M.test_template = [[package %s

import (
	"testing"
)

func Test%s(t *testing.T) {
	t.Run("should create valid instance", func(t *testing.T) {
		// Test implementation
	})
}

func Benchmark%s(b *testing.B) {
	for i := 0; i < b.N; i++ {
		// Benchmark implementation
	}
}
]]

-- Dockerfile template
M.dockerfile = [[# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o main .

# Final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]
]]

-- Makefile template
M.makefile = [[# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod

BINARY_NAME=%s
BINARY_UNIX=$(BINARY_NAME)_unix

# Build targets
.PHONY: all build clean test deps run docker

all: test build

build:
	$(GOBUILD) -o $(BINARY_NAME) -v

test:
	$(GOTEST) -v ./...

test-coverage:
	$(GOTEST) -v -coverprofile=coverage.out ./...
	$(GOCMD) tool cover -html=coverage.out

clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
	rm -f $(BINARY_UNIX)
	rm -f coverage.out

deps:
	$(GOMOD) download
	$(GOMOD) tidy

run:
	$(GOBUILD) -o $(BINARY_NAME) -v ./...
	./$(BINARY_NAME)

docker-build:
	docker build -t $(BINARY_NAME):latest .

docker-run:
	docker run -p 8080:8080 $(BINARY_NAME):latest

# Cross compilation
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) -v
]]

-- .gitignore template
M.gitignore = [[# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with `go test -c`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Dependency directories (remove the comment below to include it)
# vendor/

# Go workspace file
go.work

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Build artifacts
/build
/dist

# Coverage files
coverage.out
coverage.html
]]

return M