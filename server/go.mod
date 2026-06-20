module forge.xela.codes/xela/flixur

go 1.25.0

require (
	forge.xela.codes/xela/flixur/pluginkit v0.0.0
	forge.xela.codes/xela/flixur/proto/go v0.0.0
	github.com/danielgtaylor/huma/v2 v2.38.0
	github.com/go-chi/chi/v5 v5.3.0
	github.com/go-chi/cors v1.2.2
	github.com/hashicorp/go-hclog v1.6.3
	github.com/hashicorp/go-plugin v1.8.0
	github.com/rs/zerolog v1.35.1
	github.com/samber/lo v1.53.0
)

replace forge.xela.codes/xela/flixur/pluginkit => ../pluginkit

replace forge.xela.codes/xela/flixur/proto/go => ../proto/go

require (
	github.com/fatih/color v1.19.0 // indirect
	github.com/fxamacker/cbor/v2 v2.9.2 // indirect
	github.com/golang/protobuf v1.5.4 // indirect
	github.com/hashicorp/yamux v0.1.2 // indirect
	github.com/mattn/go-colorable v0.1.15 // indirect
	github.com/mattn/go-isatty v0.0.22 // indirect
	github.com/oklog/run v1.2.0 // indirect
	github.com/x448/float16 v0.8.4 // indirect
	golang.org/x/net v0.56.0 // indirect
	golang.org/x/sys v0.46.0 // indirect
	golang.org/x/text v0.38.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20260618152121-87f3d3e198d3 // indirect
	google.golang.org/grpc v1.81.1 // indirect
	google.golang.org/protobuf v1.36.11 // indirect
)
