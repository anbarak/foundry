# ~/.p10k-tiny-aws.zsh
function prompt_aws_tiny() {
  if [[ -n "$AWS_PROFILE" ]]; then
    local short="${AWS_PROFILE}"
    # Optional: truncate if it's too long
    if [[ ${#short} -gt 16 ]]; then
      short="${short[1,4]}..${short[-4,-1]}"
    fi
    p10k segment -f 208 -i '' -t "${short}"
  fi
}
