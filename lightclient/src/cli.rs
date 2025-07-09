use structopt::StructOpt;

#[derive(StructOpt)]
pub struct Cli {
    #[structopt(long)]
    pub sync_header: Option<String>,
    #[structopt(long)]
    pub get_latest: bool,
}

fn main() {
    let cli = Cli::from_args();
    let mut lc = lightclient::LightClient::new();
    if let Some(header) = cli.sync_header {
        // parse header from JSON or hex
        let hdr = parse_header(header);
        lc.sync_header(hdr);
        println!("Header synced!");
    }
    if cli.get_latest {
        println!("{:?}", lc.get_latest());
    }
}