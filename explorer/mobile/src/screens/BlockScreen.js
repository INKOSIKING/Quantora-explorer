import React, { useEffect, useState } from "react";
import { View, Text, StyleSheet } from "react-native";
import { getBlockByHash } from "../api/explorer";
export default function BlockScreen({ route }) {
  const { blockHash } = route.params;
  const [block, setBlock] = useState(null);
  const [error, setError] = useState("");
  useEffect(() => {
    getBlockByHash(blockHash)
      .then(setBlock)
      .catch(e => setError(e.message));
  }, [blockHash]);
  if (error) return <Text style={styles.error}>{error}</Text>;
  if (!block) return <Text>Loading...</Text>;
  return (
    <View style={styles.container}>
      <Text style={styles.header}>Block {block.height}</Text>
      <Text>Hash: {block.hash}</Text>
      <Text>Txs: {block.tx_count}</Text>
    </View>
  );
}
const styles = StyleSheet.create({
  container: { padding: 16 },
  header: { fontSize: 18, fontWeight: "bold" },
  error: { color: "red" }
});