import React, { useState } from "react";
import { View, Text, TextInput, Button, Alert } from "react-native";

export default function RecoveryScreen() {
  const [mnemonic, setMnemonic] = useState("");
  const [restoring, setRestoring] = useState(false);

  const handleRestore = () => {
    setRestoring(true);
    // Simulate wallet recovery logic
    setTimeout(() => {
      setRestoring(false);
      Alert.alert("Success", "Wallet recovered successfully!");
    }, 1500);
  };

  return (
    <View style={{ flex: 1, justifyContent: "center", padding: 20 }}>
      <Text style={{ fontSize: 20, marginBottom: 10 }}>Recover Wallet</Text>
      <TextInput
        placeholder="Enter recovery phrase"
        value={mnemonic}
        onChangeText={setMnemonic}
        multiline
        style={{ borderWidth: 1, borderColor: "#ccc", borderRadius: 4, padding: 8, marginBottom: 16 }}
      />
      <Button
        title={restoring ? "Restoring..." : "Restore"}
        onPress={handleRestore}
        disabled={restoring || mnemonic.trim().split(" ").length < 12}
      />
    </View>
  );
}