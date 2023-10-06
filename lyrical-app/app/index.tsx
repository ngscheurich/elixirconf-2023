import { useState, useEffect } from "react";
import { StatusBar } from "expo-status-bar";
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  Pressable,
  SafeAreaView,
} from "react-native";
import { Link } from "expo-router";
import Feather from "@expo/vector-icons/Feather";
import { socket } from "../network";

export default function Page() {
  const [songs, setSongs] = useState([]);

  useEffect(() => {
    const channel = socket.channel("songs", {});
    channel.join().receive("ok", (payload) => setSongs(payload));
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.heading}>
        <Text style={styles.headingText}>Songs</Text>
      </View>
      <FlatList
        contentContainerStyle={styles.container}
        data={songs}
        renderItem={({ item }) => <Item item={item} />}
        keyExtractor={(item) => item.title}
      />
      <StatusBar style="light" />
    </SafeAreaView>
  );
}

const Item = ({ item }) => (
  <View style={styles.item}>
    <Link href={{ pathname: "/song/[id]", params: { id: item.id } }} asChild>
      <Pressable onPress={() => null} style={styles.itemInner}>
        <Text style={styles.itemText}>{item.title}</Text>
        <Feather name="chevron-right" size={32} color="#C2A2CB" />
      </Pressable>
    </Link>
  </View>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#0B030C",
  },
  heading: {
    paddingLeft: 20,
    paddingRight: 20,
    paddingBottom: 20,
    paddingTop: 40,
    borderBottomColor: "#C2A2CB",
    borderBottomWidth: 1,
  },
  headingText: {
    color: "#C2A2CB",
    fontFamily: "DMSerifDisplay-Regular",
    fontSize: 48,
  },
  item: {
    borderBottomColor: "#38263D",
    borderBottomWidth: 1,
    padding: 20,
  },
  itemInner: {
    width: "100%",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  itemText: {
    color: "#eee",
    fontFamily: "Montserrat-SemiBold",
    fontSize: 16,
  },
});
