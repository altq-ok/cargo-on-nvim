use std::{env, fs, path::PathBuf, process::Command};

fn git_sha() -> Result<String, String> {
    let sha = Command::new("git")
        .args(["rev-parse", "HEAD"])
        .output()
        .map_err(|e| e.to_string())?;

    if !sha.status.success() {
        return Err("git rev-parse failed".into());
    }

    String::from_utf8(sha.stdout)
        .map(|s| s.trim().to_string())
        .map_err(|e| e.to_string())
}

fn main() {
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let target_dir = out_dir
        .parent()
        .and_then(|p| p.parent())
        .and_then(|p| p.parent())
        .unwrap();
    let version_path = target_dir.join("version");

    // get current sha from git
    let sha = match git_sha() {
        Ok(sha) => sha,
        Err(e) => {
            println!("cargo:warning=failed to get sha: {e}");
            "unknown".to_string()
        }
    };

    // write version file
    if let Err(e) = fs::write(&version_path, &sha) {
        println!("cargo:warning=failed to write version file: {e}");
    }
}
