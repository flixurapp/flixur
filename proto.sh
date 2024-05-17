# Compile all protobufs for go.
protoc -I=./proto --go_out=./proto/goproto --go_opt=paths=source_relative ./proto/*.proto
# Remove the omitempty flag from json that isnt "optional" (with *).
sed -i '/\*.*omitempty/!s/,omitempty//' ./proto/goproto/*.pb.go