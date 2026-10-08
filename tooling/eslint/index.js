const js = require("@eslint/js");
const preferArrow = require("eslint-plugin-prefer-arrow");
const tseslint = require("typescript-eslint");

/**
 * Base ESLint config shared by every packages/* member. Type-aware
 * typescript-eslint rules plus a house style: arrow functions only (no
 * `function` declarations/expressions), no-shadow, no-param-reassign, and a
 * handful of other safety/style rules. Each consuming package's own
 * eslint.config.js spreads this array and adds its own `parserOptions.project`.
 *
 * @type {import("eslint").Linter.Config[]}
 */
module.exports = tseslint.config(
    js.configs.recommended,
    ...tseslint.configs.recommendedTypeChecked,
    {
        plugins: { "prefer-arrow": preferArrow },
        rules: {
            // Type safety
            "@typescript-eslint/no-explicit-any": "error",
            "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_", varsIgnorePattern: "^_" }],
            "@typescript-eslint/consistent-type-imports": ["error", { prefer: "type-imports" }],
            // Callers decide whether to await — not every fire-and-forget call is a bug.
            "@typescript-eslint/no-floating-promises": "off",
            // TS already covers these; the base-ESLint versions just produce false positives.
            "no-undef": "off",
            "no-undefined": "off",
            "no-unused-vars": "off",

            // House style — arrow functions only, no `function` declarations/expressions.
            "prefer-arrow/prefer-arrow-functions": [
                "error",
                { disallowPrototype: true, singleReturnOnly: false, classPropertiesAllowed: false },
            ],
            "func-style": ["error", "declaration", { allowArrowFunctions: true }],
            "arrow-body-style": ["error", "as-needed"],

            // General safety/style.
            "no-shadow": "error",
            "no-param-reassign": "error",
            "no-else-return": "error",
            "no-lonely-if": "error",
            "prefer-const": ["error", { destructuring: "all" }],
            "no-void": ["error", { allowAsStatement: true }],
            "block-scoped-var": "error",
            "array-callback-return": "error",
            "spaced-comment": "error",
            strict: "error",
        },
    },
);
