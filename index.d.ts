import * as cheerio from "cheerio";

export type Callback<T> = (err: any, result: T) => void;

export type ParseMode = 'xmlstring' | 'dom' | 'js';

export default class Ableton {
    public path: string;
    public parseMode: ParseMode;
    constructor(path: string, parseMode?: ParseMode)
    read(callback: Callback<cheerio.Root>): void;
    write(xml: string, callback: Callback<void>);
}
