# shellcheck shell=bash
# =============================================================================
# Custom Aliases
# =============================================================================
alias edit_zshrc='vim ~/.zshrc'
alias src_zshrc='source ~/.zshrc'
alias edit_zshrc_local='vim ~/.zshrc.local'
alias edit_zshrc_plugins='vim ~/.zshrc.plugins'
alias edit_tmux='vim ~/.tmux.conf'
alias src_tmux='tmux source ~/.tmux.conf'
alias abzaarak='cd ~/code/my/abzaarak'
alias ccf='cd $CF_CODE'
alias cmy='cd $MY_CODE'

# =============================================================================
# Whisper CLI Configuration & Transcription Tools
# =============================================================================

export WHISPER_MODEL_DIR="$HOME/.local/share/whisper/models"

# =============================================================================
# Transcribe any audio/video file (auto converts, multilingual model support)
# =============================================================================
function transcribe() {
  local input="$1"
  local model="${2:-$WHISPER_MODEL_DIR/ggml-large-v3.bin}"
  local tmp_wav="/tmp/$(basename "$input").wav"

  if [[ "$input" == *.m4a || \
        "$input" == *.mp3 || \
        "$input" == *.webm || \
        "$input" == *.ogg || \
        "$input" == *.mp4 || \
        "$input" == *.mov ]]; then
    echo "🎧 Converting to WAV..."
    ffmpeg -y -i "$input" -ar 16000 -ac 1 -c:a pcm_s16le "$tmp_wav" >/dev/null 2>&1
    input="$tmp_wav"
  fi

  echo "🧠 Transcribing with Whisper model: $(basename "$model")"
  whisper-cli -m "$model" -f "$input"
}

# =============================================================================
# Record System Audio (BlackHole 2ch must be set as output)
# =============================================================================
function record-system-audio() {
  local out="$HOME/recordings/system-audio.wav"
  mkdir -p "$(dirname "$out")"
  echo "🎙️ Recording system audio... Press Ctrl+C to stop."
  ffmpeg -f avfoundation -i ":BlackHole 2ch" -ac 1 -ar 16000 -c:a pcm_s16le "$out"
}

# =============================================================================
# Transcribe Live System Audio Recording
# =============================================================================
function transcribe-live() {
  local input="$HOME/recordings/system-audio.wav"
  local model="${1:-$WHISPER_MODEL_DIR/ggml-large-v3.bin}"

  if [[ ! -f "$input" ]]; then
    echo "❌ Recording not found at $input"
    return 1
  fi

  echo "🧠 Transcribing recorded system audio..."
  whisper-cli -m "$model" -f "$input"
}

# =============================================================================
# Useful Aliases
# =============================================================================
alias transcribe-copy='transcribe-copy'
alias transcribe-fast='transcribe $1 $WHISPER_MODEL_DIR/ggml-base.en.bin'
alias transcribe-medium='transcribe $1 $WHISPER_MODEL_DIR/ggml-medium.en.bin'
alias record-and-transcribe='record-system-audio && transcribe-live'
alias record-and-copy='record-system-audio && transcribe-live > /tmp/live.txt && pbcopy < /tmp/live.txt && echo "📋 Copied to clipboard."'
