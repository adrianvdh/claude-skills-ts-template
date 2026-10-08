import { describe, expect, it } from "bun:test";
import type { TextStats } from "text-stats-shared";

describe("cli", () => {
    it("prints word/sentence/reading-time stats as JSON", () => {
        const result = Bun.spawnSync({
            cmd: ["bun", "run", `${import.meta.dir}/cli.ts`],
            stdin: Buffer.from("One two three. Four five six!"),
            stdout: "pipe",
        });
        const stats = JSON.parse(result.stdout.toString()) as TextStats;
        expect(stats.words).toBe(6);
        expect(stats.sentences).toBe(2);
    });
});
