import React, { useState } from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import HomeScreen from "./src/screens/HomeScreen";
import BlockScreen from "./src/screens/BlockScreen";
import TxScreen from "./src/screens/TxScreen";
import AddressScreen from "./src/screens/AddressScreen";
import SearchBar from "./src/components/SearchBar";
import { SafeAreaProvider } from "react-native-safe-area-context";

const Stack = createStackNavigator();

export default function App() {
  const [query, setQuery] = useState("");
  return (
    <SafeAreaProvider>
      <NavigationContainer>
        <SearchBar value={query} onChange={setQuery} />
        <Stack.Navigator initialRouteName="Home">
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="Block" component={BlockScreen} />
          <Stack.Screen name="Tx" component={TxScreen} />
          <Stack.Screen name="Address" component={AddressScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}