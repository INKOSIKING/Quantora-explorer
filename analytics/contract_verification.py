import solcx, json, requests

def verify_contract(source_code, compiler_version, contract_address, explorer_api_url):
    solcx.install_solc(compiler_version)
    compiled = solcx.compile_source(source_code, output_values=["abi", "bin"], solc_version=compiler_version)
    # Get deployed bytecode from explorer API
    onchain_bytecode = requests.get(f"{explorer_api_url}/contract/{contract_address}/bytecode").json()["bytecode"]
    for name, contract in compiled.items():
        if contract["bin"] == onchain_bytecode:
            # Save ABI, mark verified
            requests.post(f"{explorer_api_url}/contract/{contract_address}/verify", json={
                "abi": contract["abi"],
                "source": source_code,
                "compiler": compiler_version
            })
            print(f"Contract verified: {name}")
            return True
    print("Verification failed")
    return False