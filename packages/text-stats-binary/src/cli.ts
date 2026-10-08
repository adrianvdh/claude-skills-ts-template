#!/usr/bin/env bun
import { readFileSync } from "node:fs";
import { analyze } from "text-stats-shared";

const readInput = (): string => {
    const [, , path] = process.argv;
    if (path === undefined) {
        return readFileSync(0, "utf8");
    }
    return readFileSync(path, "utf8");
};

const main = (): void => {
    const text = readInput();
    const stats = analyze(text);
    console.log(JSON.stringify(stats, null, 2));
};

main();
