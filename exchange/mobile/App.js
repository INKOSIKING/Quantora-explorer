import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import TradeScreen from "./src/screens/TradeScreen";
import WalletScreen from "./src/screens/WalletScreen";
import MarketsScreen from "./src/screens/MarketsScreen";
import OrdersScreen from "./src/screens/OrdersScreen";
import SettingsScreen from "./src/screens/SettingsScreen";

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator initialRouteName="Markets">
        <Tab.Screen name="Markets" component={MarketsScreen} />
        <Tab.Screen name="Trade" component={TradeScreen} />
        <Tab.Screen name="Wallet" component={WalletScreen} />
        <Tab.Screen name="Orders" component={OrdersScreen} />
        <Tab.Screen name="Settings" component={SettingsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}