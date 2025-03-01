use std::{env, path::PathBuf, str::FromStr};

use pilota_build::plugin::SerdePlugin;

fn main() {
    let music_proto = PathBuf::from_str("music.proto").unwrap();
    let target_dir = env::var("OUT_DIR").unwrap();
    let out_path = PathBuf::from_str(&target_dir).unwrap().join("music.rs");

    pilota_build::Builder::protobuf()
        .ignore_unused(false)
        .include_dirs(vec![".".into()])
        .plugin(SerdePlugin)
        .compile_with_config(
            vec![pilota_build::IdlService::from_path(music_proto)],
            pilota_build::Output::File(out_path),
        );
}
