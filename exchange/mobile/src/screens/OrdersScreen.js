import React, { useEffect, useState } from "react";
import { View, Text, FlatList, StyleSheet } from "react-native";
import { getOrders } from "../api/orders";

export default function OrdersScreen() {
  const [orders, setOrders] = useState([]);
  useEffect(() => {
    getOrders().then(setOrders);
  }, []);
  return (
    <View style={styles.container}>
      <Text style={styles.header}>My Orders</Text>
      <FlatList
        data={orders}
        keyExtractor={item => item.id}
        renderItem={({ item }) => (
          <View style={styles.row}>
            <Text>{item.symbol}</Text>
            <Text>{item.side.toUpperCase()} {item.amount} @ {item.price}</Text>
            <Text>Status: {item.status}</Text>
          </View>
        )}
      />
    </View>
  );
}
const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  header: { fontSize: 22, fontWeight: "bold", marginBottom: 10 },
  row: { padding: 8, borderBottomWidth: 1, borderColor: "#eee" }
});