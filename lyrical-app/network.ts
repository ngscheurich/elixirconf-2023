import { Socket } from "phoenix";

const socket = new Socket("ws://127.0.0.1:4000/socket", {});

socket.connect();

export { socket };

export function joinSongsChannel(onJoin: (payload: object) => void) {
  const channel = socket.channel("songs", {});

  channel
    .join()
    .receive("ok", (payload) => onJoin(payload))
    .receive("error", (resp) => console.log("Unable to join", resp));
}

export function joinSongChannel(id: number, onJoin: (payload: object) => void) {
  const channel = socket.channel(`song:${id}`, {});

  channel
    .join()
    .receive("ok", (payload) => onJoin(payload))
    .receive("error", (resp) => console.log("Unable to join", resp));

  // channel.on("new_average", ({ average: count }) => updateCounter(counter, count));
}

export function getStanza(
  songId: number,
  ordinal: number,
  onReceive: (payload: object) => void
) {
  const channel = socket.channel(`song:${songId}`, {});

  channel
    .join()
    .receive("error", (resp) => console.log("Unable to join", resp));

  channel
    .push("stanza:get", { ordinal: ordinal })
    .receive("ok", (payload) => onReceive(payload));
}
