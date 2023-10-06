/**
 * This file will automatically be loaded by vite and run in the "renderer" context.
 * To learn more about the differences between the "main" and the "renderer" context in
 * Electron, visit:
 *
 * https://electronjs.org/docs/tutorial/application-architecture#main-and-renderer-processes
 *
 * By default, Node.js integration in this file is disabled. When enabling Node.js integration
 * in a renderer process, please be aware of potential security implications. You can read
 * more about security risks here:
 *
 * https://electronjs.org/docs/tutorial/security
 *
 * To enable Node.js integration in this file, open up `main.ts` and enable the `nodeIntegration`
 * flag:
 *
 * ```
 *  // Create the browser window.
 *  mainWindow = new BrowserWindow({
 *    width: 800,
 *    height: 600,
 *    webPreferences: {
 *      nodeIntegration: true
 *    }
 *  });
 * ```
 */

import "./index.css";
import { Socket } from "phoenix";

let counter: HTMLElement | null = null;

document.addEventListener("DOMContentLoaded", () => {
  counter = document.querySelector("#counter");
  updateCounter(counter, 0);
});

const socket = new Socket("ws://localhost:4000/socket", {});

socket.connect();

const channel = socket.channel("watcher", {});

channel
  .join()
  .receive("ok", ({ average: count }) => updateCounter(counter, count))
  .receive("error", (resp) => console.log("Unable to join", resp));

channel.on("new_average", ({ average: count }) =>
  updateCounter(counter, count)
);

const updateCounter = (counter: HTMLElement, count: number) => {
  if (counter) counter.textContent = count.toString();
};
