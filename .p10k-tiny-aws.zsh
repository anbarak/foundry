# ~/.p10k-tiny-aws.zsh

function prompt_aws_tiny() {
  if [[ -n "$AWS_PROFILE" && "$AWS_PROFILE" != "default" ]]; then
    local short="${AWS_PROFILE}"
    if [[ ${#short} -gt 20 ]]; then
      short="${short[1,9]}..${short[-9,-1]}"
    fi
    # Minimal icon 🅐 or keep cloud: 
    p10k segment -f 208 -i '🅐' -t "${short}"
  fi
}
