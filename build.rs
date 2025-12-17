use std::env;
use std::fs;
use std::path::Path;

fn main() {
    // Add .exe to binary name for Windows
    let bin = if cfg!(windows) {
        "cargo-on-nvim.exe"
    } else {
        "cargo-on-nvim"
    };

    // Copy from /target/release to /bin
    let src = Path::new("target").join("release").join(bin);

    let bin_dir = Path::new("bin");
    fs::create_dir_all(bin_dir).ok();

    let dst = bin_dir.join(bin);
    let _ = fs::copy(&src, &dst);

    // Print rerun criteria
    println!("cargo:rerun-if-changed=build.rs");
}
