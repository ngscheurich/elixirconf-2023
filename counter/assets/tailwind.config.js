// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
    content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
    theme: {
        extend: {
            colors: {
                slides: {
                    dark: "#0D030D",
                    medium: "#9B789F",
                    light: "#F2F2F2",
                },
            },
        },
    },
    plugins: [
        require("@tailwindcss/forms"),
        // Allows prefixing tailwind classes with LiveView classes to add rules
        // only when LiveView classes are applied, for example:
        //
        //     <div class="phx-click-loading:animate-ping">
        //
        plugin(({ addVariant }) =>
            addVariant("phx-no-feedback", [
                ".phx-no-feedback&",
                ".phx-no-feedback &",
            ])
        ),
        plugin(({ addVariant }) =>
            addVariant("phx-click-loading", [
                ".phx-click-loading&",
                ".phx-click-loading &",
            ])
        ),
        plugin(({ addVariant }) =>
            addVariant("phx-submit-loading", [
                ".phx-submit-loading&",
                ".phx-submit-loading &",
            ])
        ),
        plugin(({ addVariant }) =>
            addVariant("phx-change-loading", [
                ".phx-change-loading&",
                ".phx-change-loading &",
            ])
        ),
    ],
};
