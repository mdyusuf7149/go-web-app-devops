# Base image for first stage
FROM golang:1.21 as base
# Selecting Work Directory
WORKDIR /app
# Copying configuration file
COPY go.mod .
# Downloading Go extention for all the dependencies
RUN go mod download
# Copying source code to working directory
COPY . .
#build the application
RUN go build -o main .

# Final stage with Distroless image
FROM gcr.io/distroless/base
# copying the binaries from previous stage
COPY --from=base /app/main .
# Copying the Static code from previous stage
COPY --from=base /app/static ./static
# Exposing the app using port 8080
EXPOSE 8080
# Command to Run the application
CMD ["./main"]