import React, { useEffect, useState } from "react";
import { View, Text, FlatList, TouchableOpacity, StyleSheet } from "react-native";
import { getMarkets } from "../api/markets";

export default function MarketsScreen({ navigation }) {
  const [markets, setMarkets] = useState([]);
  useEffect(() => {
    getMarkets().then(setMarkets);
  }, []);
  return (
    <View style={styles.container}>
      <Text style={styles.header}>Markets</Text>
      <FlatList
        data={markets}
        keyExtractor={item => item.symbol}
        renderItem={({ item }) => (
          <TouchableOpacity onPress={() => navigation.navigate("Trade", { symbol: item.symbol })}>
            <View style={styles.marketRow}>
              <Text style={styles.symbol}>{item.symbol}</Text>
              <Text>{item.last_price}</Text>
            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  header: { fontSize: 22, fontWeight: "bold", marginBottom: 10 },
  marketRow: { flexDirection: "row", justifyContent: "space-between", paddingVertical: 8, borderBottomWidth: 1, borderColor: "#eee" },
  symbol: { fontWeight: "bold" }
});