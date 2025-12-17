use std::{env, fs, path::PathBuf, process::Command};

fn git_sha() -> Result<String, String> {
    let output = Command::new("git")
        .args(["rev-parse", "HEAD"])
        .output()
        .map_err(|e| e.to_string())?;

    if !output.status.success() {
        return Err("git rev-parse failed".into());
    }

    String::from_utf8(output.stdout)
        .map(|s| s.trim().to_string())
        .map_err(|e| e.to_string())
}

fn main() {
    // use OUT_DIR instead of target/release
    let out_dir = match env::var("OUT_DIR") {
        Ok(v) => PathBuf::from(v),
        Err(_) => {
            println!("cargo:warning=OUT_DIR not set");
            return;
        }
    };
    let version_path = out_dir.join("version");

    // get current sha from git
    let sha = match git_sha() {
        Ok(sha) => sha,
        Err(e) => {
            println!("cargo:warning=failed to get sha: {e}");
            "unknown".to_string()
        }
    };

    // write version file
    if let Err(e) = fs::write(&version_path, sha) {
        println!("cargo:warning=failed to write version file: {e}");
    }

    println!("cargo:rerun-if-changed=.git/HEAD");
    println!("cargo:rerun-if-changed=.git/refs");
    println!("cargo:rerun-if-changed=build.rs");
}
