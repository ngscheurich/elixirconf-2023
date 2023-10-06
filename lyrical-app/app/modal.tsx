import { useEffect, useState } from "react";
import { Alert, Pressable, StyleSheet, Text, View } from "react-native";
import { useLocalSearchParams, Link, router } from "expo-router";
import { StatusBar } from "expo-status-bar";
import { socket } from "../network";

export default function Modal() {
  const { songId } = useLocalSearchParams();
  const [channel, setChannel] = useState();

  const [stanza, setStanza] = useState({ ordinal: 1, lines: [] });

  useEffect(() => {
    const channel = socket.channel(`song:${songId}`, {});
    channel.join();

    channel
      .push("stanza:get", { ordinal: 1 })
      .receive("ok", (stanza) => setStanza(stanza));

    channel.on("like", (payload) => Alert.alert("A like!"));

    setChannel(channel);
  }, []);

  const getPrevStanza = (channel) =>
    channel
      .push("stanza:prev", {})
      .receive("ok", (stanza) => setStanza(stanza));

  const getNextStanza = (channel) =>
    channel
      .push("stanza:next", {})
      .receive("ok", (stanza) => setStanza(stanza));

  return (
    <View style={styles.container}>
      <Pressable
        onPress={() => getPrevStanza(channel)}
        style={styles.pressLeft}
      />
      <Pressable
        onPress={() => getNextStanza(channel)}
        style={styles.pressRight}
      />
      {stanza.lines.map((line, i) => (
        <Text key={i} style={styles.line}>
          {line}
        </Text>
      ))}
      <StatusBar style="light" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    padding: 20,
    backgroundColor: "#211822",
  },
  line: {
    color: "#F2E2F6",
    fontFamily: "Montserrat-SemiBold",
    fontSize: 22,
    lineHeight: 36,
    marginBottom: 16,
  },
  pressLeft: {
    width: "50%",
    height: "100%",
    position: "absolute",
    left: 0,
    top: 0,
    zIndex: 9999,
  },
  pressRight: {
    width: "50%",
    height: "100%",
    position: "absolute",
    right: 0,
    top: 0,
    zIndex: 9999,
  },
});
