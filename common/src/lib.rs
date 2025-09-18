use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Artist {
	pub id: u32,
	pub name: String,
	pub description: Option<String>,
	pub icon: Option<String>,
	pub location: Option<String>,
	pub followers: u32,
	pub rating: u32,
}
