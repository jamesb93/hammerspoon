hyper = {"cmd", "shift"}

function fuzzy(choices, func)
  local chooser = hs.chooser.new(func)
  chooser:choices(choices)
  chooser:searchSubText(true)
  chooser:width(20)
  chooser:rows(4)
  chooser:show()
end

function showAudioFuzzy()
  local devices = hs.audiodevice.allDevices()
  local choices = {}
  local active_input = hs.audiodevice.defaultInputDevice()
  local active_output = hs.audiodevice.defaultOutputDevice()
  local active, subtext
   
  for i=1, #devices do
    if devices[i]:isOutputDevice() then
      active = devices[i]:uid() == active_output:uid()
      if active then subtext = "Active" else subtext = "" end
      choices[#choices+1] = {
        text = devices[i]:name(),
        uid = devices[i]:uid(),
        subText = subtext,
        valid = not active,
      }
    end
  end
  fuzzy(choices, selectAudio)
end

function selectAudio(audio)
  if audio == nil then -- nothing selected
    return
  end
  local device = hs.audiodevice.findDeviceByUID(audio.uid)
  if device:isOutputDevice() then
    device:setDefaultOutputDevice()
  end
end

hs.hotkey.bind(hyper, "space", showAudioFuzzy)
