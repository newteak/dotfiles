local caps_mode = hs.hotkey.modal.new()
local inputEnglish = "com.apple.keylayout.US"

local on_caps_mode = function()
    caps_mode:enter()
end

local off_caps_mode = function()

    caps_mode:exit()

    local input_source = hs.keycodes.currentSourceID()

    if not (input_source == inputEnglish) then
        hs.keycodes.currentSourceID(inputEnglish)
    end
    hs.eventtap.keyStroke({}, 'escape')
end

hs.hotkey.bind({}, 'f13', on_caps_mode, off_caps_mode)