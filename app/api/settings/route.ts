import { NextResponse } from "next/server";
import { readFileSync, writeFileSync } from "fs";
import { join } from "path";
import { getAgentDir } from "@earendil-works/pi-coding-agent";

export async function PATCH(req: Request) {
  try {
    const body = await req.json() as { key: string; value: unknown };
    const { key, value } = body;
    if (!key) return NextResponse.json({ error: "key required" }, { status: 400 });

    const agentDir = getAgentDir();
    const settingsPath = join(agentDir, "settings.json");

    let settings: Record<string, unknown> = {};
    try {
      settings = JSON.parse(readFileSync(settingsPath, "utf-8"));
    } catch { /* file may not exist */ }

    settings[key] = value;
    writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + "\n", "utf-8");

    return NextResponse.json({ ok: true });
  } catch (e) {
    return NextResponse.json({ error: String(e) }, { status: 500 });
  }
}

export async function GET() {
  try {
    const agentDir = getAgentDir();
    const settingsPath = join(agentDir, "settings.json");
    let settings: Record<string, unknown> = {};
    try {
      settings = JSON.parse(readFileSync(settingsPath, "utf-8"));
    } catch { /* file may not exist */ }
    return NextResponse.json(settings);
  } catch (e) {
    return NextResponse.json({ error: String(e) }, { status: 500 });
  }
}
