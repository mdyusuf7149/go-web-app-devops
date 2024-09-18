# Using base image for first stage
FROM golang:1.21 as base
# selecting work directory
WORKDIR /app
# copying the static files
COPY go.mod .
# Downloading the dependencies
RUN go mod download
# copying the dependencies
COPY . .
# Running the application
RUN go build -o main .

# Final stage with distroless image 
FROM gcr.io/distroless/base
#copying binary files from stage1
COPY --from=base /app/main .
#copying static files from stage1
COPY --from=base /app/static ./static
#Exposing the application to port
EXPOSE  8080
#Running the application
CMD ["./main"]