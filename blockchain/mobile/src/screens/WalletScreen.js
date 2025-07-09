import React, { useEffect, useState } from "react";
import { View, Text, Button, StyleSheet } from "react-native";
import { getWalletBalance, sendToken } from "../api/wallet";

export default function WalletScreen() {
  const [balance, setBalance] = useState(null);
  const [error, setError] = useState("");
  const [refreshing, setRefreshing] = useState(false);

  const fetchBalance = async () => {
    setRefreshing(true);
    try {
      const bal = await getWalletBalance();
      setBalance(bal);
      setError("");
    } catch (e) {
      setError(e.message);
    }
    setRefreshing(false);
  };

  useEffect(() => { fetchBalance(); }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Wallet Balance</Text>
      <Text style={styles.balance}>{balance !== null ? balance + " QTX" : "Loading..."}</Text>
      {error ? <Text style={styles.error}>{error}</Text> : null}
      <Button title="Refresh" onPress={fetchBalance} disabled={refreshing} />
      {/* Add send/receive logic here */}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: "center", alignItems: "center" },
  header: { fontSize: 24, fontWeight: "bold" },
  balance: { fontSize: 32, margin: 20 },
  error: { color: "red" }
});