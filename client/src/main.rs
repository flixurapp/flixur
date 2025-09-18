use tracing_subscriber::fmt;
use tracing_subscriber_wasm::MakeConsoleWriter;

fn main() {
	fmt()
		.with_writer(
			MakeConsoleWriter::default()
				.map_trace_level_to(tracing::Level::DEBUG),
		)
		.without_time()
		.init();
}
