import { useState, useEffect } from "react";
import { StatusBar } from "expo-status-bar";
import { Image } from "expo-image";
import { Pressable, StyleSheet, Text, View } from "react-native";
import { useLocalSearchParams, Link, Stack } from "expo-router";
import { socket } from "../../network";

export default function Page() {
  const { id } = useLocalSearchParams();
  const [song, setSong] = useState();

  useEffect(() => {
    const channel = socket.channel(`song:${id}`, {});
    channel.join().receive("ok", (payload) => setSong(payload));
  }, []);

  return (
    <View style={styles.container}>
      {song ? (
        <>
          <Song key={song.title} song={song} />
          <Button songId={song.id} />
          <Stack.Screen options={{ title: song.title }} />
        </>
      ) : null}
      <StatusBar style="light" />
      <Stack.Screen options={{ title: null }} />
    </View>
  );
}

const Song = ({ song }) => (
  <View>
    <Image
      contentFit="cover"
      transition={500}
      style={styles.image}
      source={song.artwork_url}
    />
    <Text style={styles.titleText}>{song.title}</Text>
    <Text style={styles.artistText}>by {song.artist}</Text>
    <Text style={styles.albumText}>
      {song.album} ({song.year})
    </Text>
  </View>
);

const Button = ({ songId }) => (
  <Link href={{ pathname: "/modal", params: { songId } }} asChild>
    <Pressable style={styles.button}>
      <Text style={styles.buttonText}>See Lyrics</Text>
    </Pressable>
  </Link>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#0B030C",
    justifyContent: "space-between",
    paddingTop: 10,
    paddingBottom: 40,
  },
  image: {
    height: 400,
    width: "100%",
    marginBottom: 5,
  },
  titleText: {
    color: "#eee",
    fontSize: 40,
    fontFamily: "DMSerifDisplay-Regular",
    lineHeight: 50,
    margin: 20,
    marginBottom: 5,
  },
  artistText: {
    color: "#eee",
    fontSize: 18,
    fontFamily: "Montserrat-SemiBold",
    margin: 20,
    marginTop: 0,
    marginBottom: 10,
  },
  albumText: {
    color: "#C2A2CB",
    fontSize: 18,
    fontFamily: "Montserrat-Regular",
    margin: 20,
    marginTop: 0,
  },
  button: {
    backgroundColor: "#81558C",
    borderRadius: 100,
    margin: 20,
    padding: 20,
  },
  buttonText: {
    color: "#eee",
    textAlign: "center",
    fontSize: 16,
    fontWeight: "bold",
    fontFamily: "Montserrat-SemiBold",
  },
});
