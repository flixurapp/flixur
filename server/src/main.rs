use axum::extract::Path;
use axum::http::StatusCode;
use axum::routing::get;
use axum::{Json, Router};
use flixur_common::Artist;
use std::net::SocketAddr;
use tokio::net::TcpListener;
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
	tracing_subscriber::fmt::init();

	let addr = "[::]:8080".parse::<SocketAddr>()?;
	// build our application with a route
	let app = Router::new()
		.route("/{library}/{artist}", get(get_artist))
		.layer(CorsLayer::permissive());

	// run it
	let listener = TcpListener::bind(addr).await?;
	println!("listening on {}", listener.local_addr()?);
	axum::serve(listener, app).await?;

	Ok(())
}

async fn get_artist(
	Path((library, artist)): Path<(String, String)>,
) -> Result<Json<Artist>, StatusCode> {
	// return dummy data for now
	let artist = Artist {
        id: 0,
        name: "Kenya Grace".into(),
        description: Some(
            "Kenya Grace is a South African-born British singer, songwriter, and record producer. She is best known for her 2023 single Strangers, which reached number one on the UK Singles Chart. ".into(),
        ),
        icon: Some("https://i1.sndcdn.com/avatars-pzpiAr9zylGm0K99-zyM6Yw-t500x500.jpg".into()),
        location: Some("United Kingdom".into()),
        followers: 1,
        rating: 4,
    };

	Ok(Json(artist))
}
