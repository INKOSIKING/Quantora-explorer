import React, { useEffect, useState } from "react";
import { View, Text, FlatList, StyleSheet } from "react-native";
import { getUserTokens } from "../api/tokens";

export default function TokensScreen() {
  const [tokens, setTokens] = useState([]);
  useEffect(() => {
    getUserTokens().then(setTokens);
  }, []);
  return (
    <View style={styles.container}>
      <Text style={styles.header}>Your Tokens</Text>
      <FlatList
        data={tokens}
        keyExtractor={item => item.address}
        renderItem={({ item }) => (
          <View style={styles.token}>
            <Text style={styles.symbol}>{item.symbol}</Text>
            <Text>{item.balance}</Text>
          </View>
        )}
      />
    </View>
  );
}
const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  header: { fontSize: 22, fontWeight: "bold", marginBottom: 10 },
  token: { padding: 8, borderBottomWidth: 1, borderColor: "#eee" },
  symbol: { fontWeight: "bold" }
});