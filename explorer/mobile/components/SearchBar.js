import React from "react";
import { View, TextInput, StyleSheet } from "react-native";
export default function SearchBar({ value, onChange }) {
  return (
    <View style={styles.bar}>
      <TextInput
        style={styles.input}
        placeholder="Block/Tx/Address"
        value={value}
        onChangeText={onChange}
      />
    </View>
  );
}
const styles = StyleSheet.create({
  bar: { padding: 10, backgroundColor: "#f2f2f2" },
  input: { height: 40, backgroundColor: "#fff", borderRadius: 6, paddingHorizontal: 10 }
});