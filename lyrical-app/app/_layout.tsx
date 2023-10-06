import { useCallback } from "react";
import { Stack } from "expo-router/stack";
import { useFonts } from "expo-font";
import * as SplashScreen from "expo-splash-screen";

SplashScreen.preventAutoHideAsync();

export default function Layout() {
  const [fontsLoaded, fontError] = useFonts({
    "DMSerifDisplay-Regular": require("../assets/fonts/DMSerifDisplay-Regular.ttf"),
    "Montserrat-Regular": require("../assets/fonts/Montserrat-Regular.ttf"),
    "Montserrat-SemiBold": require("../assets/fonts/Montserrat-SemiBold.ttf"),
    "NotoSerif-Regular": require("../assets/fonts/NotoSerif-Regular.ttf"),
    "NotoSerif-Light": require("../assets/fonts/NotoSerif-Light.ttf"),
  });

  const onLayoutRootView = useCallback(async () => {
    if (fontsLoaded || fontError) {
      await SplashScreen.hideAsync();
    }
  }, [fontsLoaded, fontError]);

  if (!fontsLoaded && !fontError) {
    return null;
  }

  return (
    <Stack
      screenOptions={{
        headerStyle: {
          backgroundColor: "#0B030C",
        },
        headerTintColor: "#C2A2CB",
        headerTitleStyle: {
          fontFamily: "Montserrat-SemiBold",
        },
      }}
    >
      <Stack.Screen name="index" options={{ headerShown: false }} />
      <Stack.Screen
        name="modal"
        options={{ headerShown: false, presentation: "modal" }}
      />
    </Stack>
  );
}
