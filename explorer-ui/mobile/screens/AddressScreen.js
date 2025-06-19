import React, { useEffect, useState } from "react";
import { View, Text, StyleSheet } from "react-native";
import { getAddressInfo } from "../api/explorer";
export default function AddressScreen({ route }) {
  const { address } = route.params;
  const [info, setInfo] = useState(null);
  const [error, setError] = useState("");
  useEffect(() => {
    getAddressInfo(address)
      .then(setInfo)
      .catch(e => setError(e.message));
  }, [address]);
  if (error) return <Text style={styles.error}>{error}</Text>;
  if (!info) return <Text>Loading...</Text>;
  return (
    <View style={styles.container}>
      <Text style={styles.header}>Address {address}</Text>
      <Text>Balance: {info.balance}</Text>
      <Text>Tx count: {info.tx_count}</Text>
      {/* More details */}
    </View>
  );
}
const styles = StyleSheet.create({
  container: { padding: 16 },
  header: { fontSize: 18, fontWeight: "bold" },
  error: { color: "red" }
});