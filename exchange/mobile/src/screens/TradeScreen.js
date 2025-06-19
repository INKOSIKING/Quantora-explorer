import React, { useEffect, useState } from "react";
import { View, Text, TextInput, Button, StyleSheet } from "react-native";
import { getOrderBook, placeOrder } from "../api/trade";

export default function TradeScreen({ route }) {
  const symbol = route?.params?.symbol || "QTX/USDT";
  const [side, setSide] = useState("buy");
  const [amount, setAmount] = useState("");
  const [price, setPrice] = useState("");
  const [orderbook, setOrderbook] = useState({ bids: [], asks: [] });
  const [message, setMessage] = useState("");

  useEffect(() => {
    getOrderBook(symbol).then(setOrderbook);
  }, [symbol]);

  const handleTrade = async () => {
    setMessage("");
    try {
      await placeOrder(symbol, side, price, amount);
      setMessage("Order placed!");
    } catch (e) {
      setMessage(e.message);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Trade {symbol}</Text>
      <View style={styles.row}>
        <Button title="Buy" onPress={() => setSide("buy")} color={side === "buy" ? "green" : "gray"} />
        <Button title="Sell" onPress={() => setSide("sell")} color={side === "sell" ? "red" : "gray"} />
      </View>
      <TextInput style={styles.input} placeholder="Price" value={price} onChangeText={setPrice} keyboardType="numeric" />
      <TextInput style={styles.input} placeholder="Amount" value={amount} onChangeText={setAmount} keyboardType="numeric" />
      <Button title="Place Order" onPress={handleTrade} />
      {message ? <Text style={styles.info}>{message}</Text> : null}
      <View style={styles.orderbook}>
        <Text style={styles.subheader}>Order Book</Text>
        <Text>Bids:</Text>
        {orderbook.bids.map((b, i) => <Text key={i}>{b[0]} @ {b[1]}</Text>)}
        <Text>Asks:</Text>
        {orderbook.asks.map((a, i) => <Text key={i}>{a[0]} @ {a[1]}</Text>)}
      </View>
    </View>
  );
}
const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  header: { fontSize: 18, fontWeight: "bold", marginBottom: 8 },
  subheader: { fontWeight: "bold", marginTop: 12 },
  row: { flexDirection: "row", justifyContent: "space-around", marginVertical: 10 },
  input: { borderWidth: 1, borderColor: "#ccc", padding: 8, marginVertical: 5, borderRadius: 5 },
  info: { color: "green", marginTop: 6, marginBottom: 6 },
  orderbook: { marginTop: 16 }
});