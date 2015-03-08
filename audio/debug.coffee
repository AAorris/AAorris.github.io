navigator.getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia)

audio = new (window.AudioContext or window.webkitAudioContext)()

audioElement = document.querySelector('audio')
logo = $('#logo')
#position = +document.cookie.split(";")[0] || 0
#startPosition = position

#audioElement.currentTime = position

canvas = document.querySelector('.visualizer')
graphics = canvas.getContext("2d")
intendedWidth = document.querySelector('.wrapper').clientWidth
intendedHeight = document.querySelector('.wrapper').clientHeight
canvas.setAttribute('width',intendedWidth)
canvas.setAttribute('height',intendedHeight)


analyser = audio.createAnalyser()
analyser.minDecibels = -70
analyser.maxDecibels = 0
analyser.smoothingTimeConstant = 0.85

#source = audio.createMediaStreamSource(stream)
#source.connect(analyser) #Now the analyser gets fft data

# if navigator.getUserMedia
#    console.log('getUserMedia supported.');
#    navigator.getUserMedia(
#       constraints =
#         audio: true
#       # Success callback
#       (stream) ->
#         source = audio.createMediaStreamSource(stream)
#         source.connect(analyser)
#         visualize()
#       #Error callback
#       (err) -> console.log('The following gUM error occured: ' + err);
#    );
# else
#    console.log('getUserMedia not supported on your browser!');

WIDTH = canvas.width
HEIGHT = canvas.height
visualize = () ->
  WIDTH = canvas.width
  HEIGHT = canvas.height
  s=0.0

  console.log("Visualizing")

  analyser.fftSize = 2048
  bufferLength = analyser.frequencyBinCount
  dataArray = new Uint8Array(bufferLength)

  graphics.clearRect(0,0,WIDTH,HEIGHT)
  draw = () ->
    drawVisual = requestAnimationFrame(draw)
    analyser.getByteFrequencyData(dataArray)
    graphics.fillStyle='rgba(10,10,10,64)'
    graphics.fillRect(0,0,WIDTH,HEIGHT)

    barWidth = (WIDTH/bufferLength) * 15
    x=0
    # logo.css("top", HEIGHT/2.5+dataArray[0]/4);
    s = 0.8+dataArray[4]/150;
    rx = dataArray[8]/5;
    logo.css("transform", "scale("+s+") rotateX("+rx+"deg)");
    for i in [0..bufferLength] by 1
      barHeight = dataArray[i]**2/50
      graphics.fillStyle = 'rgb(' + (dataArray[i]+100+',50,50)')
      graphics.fillRect(x,HEIGHT-barHeight,barWidth,barHeight)
      x+=barWidth+10
  draw()
  setInterval(()->
    songTime=audio.currentTime+startPosition
    document.cookie=songTime
    console.log(songTime)
  1000)

source = audio.createMediaElementSource(document.querySelector('audio'))
source.connect(analyser)
analyser.connect(audio.destination)
visualize()

window.onresize = () ->
  intendedWidth = document.querySelector('.wrapper').clientWidth
  intendedHeight = document.querySelector('.wrapper').clientHeight
  canvas.setAttribute('width',intendedWidth)
  canvas.setAttribute('height',intendedHeight)
  WIDTH = canvas.width
  HEIGHT = canvas.height
##======================================
# dataArray = new Uint8Array(bufferLength)
##======================================

# data="byte"
# domain="time"

# switch
#   when data is "byte" and domain is "frequency" then analyser.getByteFrequencyData(dataArray)
#   when data is "byte" and domain is "time" then analyser.getByteTimeDomainData(dataArray)
#   when data is "float" and domain is "frequency" then analyser.getFloatFrequencyData(dataArray)
#   when data is "float" and domain is "time" then analyser.getFloatTimeDomainData(dataArray)
