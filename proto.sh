# Compile all protobufs for go.
protoc -I=./proto --go_out=./proto/go --go_opt=paths=source_relative ./proto/artist.proto
