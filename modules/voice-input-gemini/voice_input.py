"""Gemini 3.5 Transcribeを使ったpush-to-talk音声入力。

ホットキーで録音開始/停止をトグルし、停止時にGemini 3.5 Transcribe
(smart transcriptionモードでフィラーワード除去)にかけ、結果をアクティブ
ウィンドウにタイプ入力してEnterまで送信する。

前提: 環境変数 GEMINI_API_KEY にGoogle AI StudioのAPIキーを設定しておく。
使い方: claudeが動いているターミナルにフォーカスした状態でこのスクリプトを
別ターミナルで起動し、F9で録音開始、もう一度F9で録音停止・自動送信。
"""
import os
import sys
import tempfile
import threading

import keyboard
import numpy as np
import sounddevice as sd
import soundfile as sf
from google import genai

HOTKEY = "f9"
SAMPLE_RATE = 16000
CHANNELS = 1

api_key = os.environ.get("GEMINI_API_KEY")
if not api_key:
    sys.exit("GEMINI_API_KEY environment variable is not set.")

client = genai.Client(api_key=api_key)

recording = False
frames = []
stream = None
lock = threading.Lock()


def _callback(indata, frame_count, time_info, status):
    with lock:
        frames.append(indata.copy())


def start_recording():
    global recording, frames, stream
    with lock:
        frames = []
    stream = sd.InputStream(samplerate=SAMPLE_RATE, channels=CHANNELS, callback=_callback)
    stream.start()
    recording = True
    print("[voice_input] recording... press F9 to stop")


def stop_recording_and_transcribe():
    global recording, stream
    stream.stop()
    stream.close()
    recording = False
    print("[voice_input] transcribing...")

    with lock:
        audio = np.concatenate(frames, axis=0) if frames else np.zeros((0, CHANNELS), dtype=np.float32)

    tmp_path = tempfile.mktemp(suffix=".wav")
    sf.write(tmp_path, audio, SAMPLE_RATE)

    try:
        audio_file = client.files.upload(file=tmp_path)
        interaction = client.interactions.create(
            model="gemini-3.5-transcribe",
            input=[{
                "type": "audio",
                "uri": audio_file.uri,
                "mime_type": audio_file.mime_type,
            }],
            generation_config={"transcription_config": {"mode": "smart"}},
        )
        text = interaction.output_text.strip()
    finally:
        os.remove(tmp_path)

    if text:
        print(f"[voice_input] -> {text}")
        keyboard.write(text)
        keyboard.send("enter")
    else:
        print("[voice_input] (empty transcription, skipped)")


def toggle():
    if recording:
        stop_recording_and_transcribe()
    else:
        start_recording()


def main():
    print(f"[voice_input] ready. Press {HOTKEY} to start/stop recording. Ctrl+C to quit.")
    keyboard.add_hotkey(HOTKEY, toggle)
    keyboard.wait()


if __name__ == "__main__":
    main()
