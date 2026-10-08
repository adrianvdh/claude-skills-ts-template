const baseConfig = require("tooling-eslint-config");

// tooling-eslint-config already exports a flat config array, so a plain array
// literal is enough here — no need to depend on typescript-eslint directly
// just to re-flatten it.
module.exports = [
    { ignores: ["node_modules/**", "dist/**", "dist-tsc/**", "eslint.config.cjs"] },
    ...baseConfig,
    {
        languageOptions: {
            parserOptions: {
                project: "./tsconfig.json",
                tsconfigRootDir: __dirname,
            },
        },
    },
];
