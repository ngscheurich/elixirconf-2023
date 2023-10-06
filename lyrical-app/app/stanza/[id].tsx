import { useState, useEffect } from "react";
import { StatusBar } from "expo-status-bar";
import { Image } from "expo-image";
import {
  Alert,
  Pressable,
  StyleSheet,
  Text,
  View,
  ScrollView,
  FlatList,
} from "react-native";
import { joinSongChannel } from "../../network";
import { useLocalSearchParams } from "expo-router";

export default function Page() {
  const local = useLocalSearchParams();

  const [stanza, setStanza] = useState();

  useEffect(() => {
    joinSongChannel(local.id, (song) => {
      setSong(song);
    });
  }, []);

  return (
    <ScrollView contentContainerStyle={styles.container}>
      {song ? (
        <>
          <Song key={song.title} song={song} />
          <Button songId={song.id} />
        </>
      ) : null}
      <StatusBar style="auto" />
    </ScrollView>
  );
}

const Song = (props) => (
  <View style={styles.song}>
    <Image style={styles.image} source={props.song.artwork_url} />
    <Text style={styles.songText}>{props.song.title}</Text>
  </View>
);

const Button = (props) => (
  <Pressable onPress={() => Alert.alert("Lyrics!")}>
    <Text>Lyrics</Text>
  </Pressable>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: "#222",
  },
  image: {
    width: "100%",
  },
  songText: {
    color: "#eee",
    textAlign: "center",
  },
});
