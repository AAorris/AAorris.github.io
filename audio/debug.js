var HEIGHT, WIDTH, analyser, audio, audioElement, canvas, graphics, intendedHeight, intendedWidth, logo, source, visualize;

navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;

audio = new (window.AudioContext || window.webkitAudioContext)();

audioElement = document.querySelector('audio');

logo = $('#logo');

canvas = document.querySelector('.visualizer');

graphics = canvas.getContext("2d");

intendedWidth = document.querySelector('.wrapper').clientWidth;

intendedHeight = document.querySelector('.wrapper').clientHeight;

canvas.setAttribute('width', intendedWidth);

canvas.setAttribute('height', intendedHeight);

analyser = audio.createAnalyser();

analyser.minDecibels = -70;

analyser.maxDecibels = 0;

analyser.smoothingTimeConstant = 0.85;

WIDTH = canvas.width;

HEIGHT = canvas.height;

visualize = function() {
  var bufferLength, dataArray, draw;
  WIDTH = canvas.width;
  HEIGHT = canvas.height;
  console.log("Visualizing");
  analyser.fftSize = 512;
  bufferLength = analyser.frequencyBinCount;
  dataArray = new Uint8Array(bufferLength);
  graphics.clearRect(0, 0, WIDTH, HEIGHT);
  draw = function() {
    var barHeight, barWidth, drawVisual, i, j, ref, results, x;
    drawVisual = requestAnimationFrame(draw);
    analyser.getByteFrequencyData(dataArray);
    graphics.fillStyle = 'rgba(10,10,10,64)';
    graphics.fillRect(0, 0, WIDTH, HEIGHT);
    barWidth = (WIDTH / bufferLength) * 2.5;
    x = 0;
    logo.css("top", HEIGHT / 2.5 + dataArray[0] / 4);
    results = [];
    for (i = j = 0, ref = bufferLength; j <= ref; i = j += 1) {
      barHeight = Math.pow(dataArray[i], 2) / 50;
      graphics.fillStyle = 'rgb(' + (dataArray[i] + 100 + ',50,50)');
      graphics.fillRect(x, HEIGHT - barHeight, barWidth, barHeight);
      results.push(x += barWidth + 1);
    }
    return results;
  };
  draw();
  return setInterval(function() {
    var songTime;
    songTime = audio.currentTime + startPosition;
    document.cookie = songTime;
    return console.log(songTime);
  }, 1000);
};

source = audio.createMediaElementSource(document.querySelector('audio'));

source.connect(analyser);

analyser.connect(audio.destination);

visualize();

window.onresize = function() {
  intendedWidth = document.querySelector('.wrapper').clientWidth;
  intendedHeight = document.querySelector('.wrapper').clientHeight;
  canvas.setAttribute('width', intendedWidth);
  canvas.setAttribute('height', intendedHeight);
  WIDTH = canvas.width;
  return HEIGHT = canvas.height;
};
