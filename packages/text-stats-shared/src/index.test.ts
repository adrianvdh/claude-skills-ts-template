import { describe, expect, it } from "bun:test";
import { analyze, countSentences, countWords } from "./index";

describe("countWords", () => {
    it("counts whitespace-separated words", () => {
        expect(countWords("one two three")).toBe(3);
    });

    it("returns 0 for empty input", () => {
        expect(countWords("   ")).toBe(0);
    });
});

describe("countSentences", () => {
    it("counts sentence-ending punctuation", () => {
        expect(countSentences("Hello world. How are you? Fine!")).toBe(3);
    });
});

describe("analyze", () => {
    it("rounds up reading time to at least one minute", () => {
        const stats = analyze("short text");
        expect(stats.words).toBe(2);
        expect(stats.readingTimeMinutes).toBe(1);
    });
});
