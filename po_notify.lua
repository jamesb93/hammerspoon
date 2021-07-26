-- notifications
function work_cb() end
work = hs.notify.new(work_cb(), {
    autoWithdraw = false,
    title = "Work",
    subTitle = "work period has ended",
    soundName = "alarm.wav"
})

rest = hs.notify.new(nil, {
    autoWithdraw = false,
    title = "Rest",
    subtitle = "rest period has ended",
    soundName = "Hero.aiff"
})

warning = hs.notify.new(nil, {
    autoWithdraw = true,
    title="Almost there!",
    subTitle = "Five minutes remaining",
    soundName = "Blow.aiff"
})