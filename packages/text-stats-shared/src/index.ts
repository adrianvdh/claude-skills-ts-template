export type TextStats = {
    readonly words: number;
    readonly sentences: number;
    readonly readingTimeMinutes: number;
};

const WORDS_PER_MINUTE = 200;

export const countWords = (text: string): number => {
    const trimmed = text.trim();
    if (trimmed.length === 0) {
        return 0;
    }
    return trimmed.split(/\s+/u).length;
};

export const countSentences = (text: string): number => {
    const matches = text.match(/[^.!?]+[.!?]+/gu);
    return matches === null ? 0 : matches.length;
};

export const analyze = (text: string): TextStats => {
    const words = countWords(text);
    const sentences = countSentences(text);
    const readingTimeMinutes = Math.max(1, Math.ceil(words / WORDS_PER_MINUTE));
    return { words, sentences, readingTimeMinutes };
};
