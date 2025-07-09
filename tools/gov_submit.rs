use substrate_api_client::{Api, XtStatus, compose_extrinsic, UncheckedExtrinsicV4, AccountKeyring};
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: gov_submit <node-url> <proposal-hex>");
        return;
    }
    let url = &args[1];
    let proposal = hex::decode(&args[2]).expect("invalid hex proposal");
    let api = Api::new(url).set_signer(AccountKeyring::Alice.pair());
    let xt: UncheckedExtrinsicV4<_> = compose_extrinsic!(
        api,
        "Governance",
        "submit_proposal",
        proposal
    );
    let tx_hash = api.send_extrinsic(xt.hex_encode(), XtStatus::InBlock).unwrap();
    println!("Proposal submitted: {:?}", tx_hash);
}