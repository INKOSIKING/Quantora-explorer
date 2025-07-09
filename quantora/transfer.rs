use crate::fees::FeeManager;

pub async fn send_tokens(
    sender: &str,
    receiver: &str,
    amount: u128,
    fee_manager: &FeeManager,
) -> Result<(), String> {
    // Charge minimal send fee
    let fee = fee_manager.config.min_send_fee;
    fee_manager.charge_send_fee(sender, fee)?;
    fee_manager.forward_fee_to_eth(fee).await?;

    // Deduct amount+fee from sender, add amount to receiver
    // (implement actual balance transfer logic here)
    Ok(())
}

pub async fn receive_tokens(
    receiver: &str,
    fee_manager: &FeeManager,
) -> Result<(), String> {
    let fee = fee_manager.config.min_receive_fee;
    fee_manager.charge_receive_fee(receiver, fee)?;
    fee_manager.forward_fee_to_eth(fee).await?;
    // (credit tokens to receiver)
    Ok(())
}