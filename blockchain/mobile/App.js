import React, { useState, useEffect } from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import WalletScreen from "./src/screens/WalletScreen";
import TokensScreen from "./src/screens/TokensScreen";
import ExplorerScreen from "./src/screens/ExplorerScreen";
import SettingsScreen from "./src/screens/SettingsScreen";
import { StatusBar, Platform } from "react-native";

const Tab = createBottomTabNavigator();

export default function App() {
  useEffect(() => {
    if (Platform.OS === "android") StatusBar.setTranslucent(true);
  }, []);
  return (
    <NavigationContainer>
      <Tab.Navigator initialRouteName="Wallet">
        <Tab.Screen name="Wallet" component={WalletScreen} />
        <Tab.Screen name="Tokens" component={TokensScreen} />
        <Tab.Screen name="Explorer" component={ExplorerScreen} />
        <Tab.Screen name="Settings" component={SettingsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}