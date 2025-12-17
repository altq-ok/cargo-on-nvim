use std::env;
use std::process::Command;

struct CargoRunner {
    // command_alias: &str -> this requires lifetime specifier
    command_alias: String,
}

impl CargoRunner {
    fn run(&self, args: &[String]) {
        let mut cmd = Command::new(&self.command_alias);
        for arg in args {
            cmd.arg(arg);
        }
        let status = cmd.status().expect("failed to execute process");
        if !status.success() {
            eprintln!("Cargo command failed with code {:?}", status.code());
        }
    }
}

fn main() {
    let alias = String::from("cargo");
    let args: Vec<String> = env::args().skip(1).collect(); // skip executable name
    let runner = CargoRunner {
        command_alias: alias,
    };
    // Execute command
    runner.run(&args);
}
