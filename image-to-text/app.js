// Image to Text Converter - OCR App using Tesseract.js

(function () {
    'use strict';

    // ===== DOM Elements =====
    var dropZone = document.getElementById('drop-zone');
    var fileInput = document.getElementById('file-input');
    var cameraBtn = document.getElementById('camera-btn');
    var previewCard = document.getElementById('preview-card');
    var previewImg = document.getElementById('preview-img');
    var removeImgBtn = document.getElementById('remove-img-btn');
    var extractBtn = document.getElementById('extract-btn');
    var progressCard = document.getElementById('progress-card');
    var progressStatus = document.getElementById('progress-status');
    var progressPercent = document.getElementById('progress-percent');
    var progressBar = document.getElementById('progress-bar');
    var resultCard = document.getElementById('result-card');
    var resultText = document.getElementById('result-text');
    var charCount = document.getElementById('char-count');
    var wordCount = document.getElementById('word-count');
    var lineCount = document.getElementById('line-count');
    var copyBtn = document.getElementById('copy-btn');
    var downloadBtn = document.getElementById('download-btn');
    var ocrLangSelect = document.getElementById('ocr-lang');
    var toast = document.getElementById('toast');

    // Camera elements
    var cameraModal = document.getElementById('camera-modal');
    var cameraVideo = document.getElementById('camera-video');
    var cameraCanvas = document.getElementById('camera-canvas');
    var captureBtn = document.getElementById('capture-btn');
    var closeCameraBtn = document.getElementById('close-camera-btn');

    // ===== State =====
    var currentImage = null;
    var cameraStream = null;

    // ===== Drag and Drop =====
    dropZone.addEventListener('dragover', function (e) {
        e.preventDefault();
        dropZone.classList.add('dragover');
    });

    dropZone.addEventListener('dragleave', function () {
        dropZone.classList.remove('dragover');
    });

    dropZone.addEventListener('drop', function (e) {
        e.preventDefault();
        dropZone.classList.remove('dragover');
        var files = e.dataTransfer.files;
        if (files.length > 0 && files[0].type.startsWith('image/')) {
            loadImage(files[0]);
        }
    });

    dropZone.addEventListener('click', function () {
        fileInput.click();
    });

    fileInput.addEventListener('change', function () {
        if (fileInput.files.length > 0) {
            loadImage(fileInput.files[0]);
        }
    });

    // ===== Load Image =====
    function loadImage(file) {
        var reader = new FileReader();
        reader.onload = function (e) {
            currentImage = e.target.result;
            previewImg.src = currentImage;
            previewCard.classList.remove('hidden');
            resultCard.classList.add('hidden');
            progressCard.classList.add('hidden');
        };
        reader.readAsDataURL(file);
    }

    // ===== Remove Image =====
    removeImgBtn.addEventListener('click', function () {
        currentImage = null;
        previewImg.src = '';
        previewCard.classList.add('hidden');
        resultCard.classList.add('hidden');
        progressCard.classList.add('hidden');
        fileInput.value = '';
    });

    // ===== Extract Text =====
    extractBtn.addEventListener('click', function () {
        if (!currentImage) return;

        var lang = ocrLangSelect.value;
        extractBtn.disabled = true;
        progressCard.classList.remove('hidden');
        resultCard.classList.add('hidden');
        progressStatus.textContent = 'Initializing OCR engine...';
        progressPercent.textContent = '0%';
        progressBar.style.width = '0%';

        Tesseract.recognize(currentImage, lang, {
            logger: function (info) {
                if (info.status === 'recognizing text') {
                    var pct = Math.round(info.progress * 100);
                    progressStatus.textContent = 'Recognizing text...';
                    progressPercent.textContent = pct + '%';
                    progressBar.style.width = pct + '%';
                } else if (info.status === 'loading tesseract core') {
                    progressStatus.textContent = 'Loading OCR engine...';
                } else if (info.status === 'initializing tesseract') {
                    progressStatus.textContent = 'Initializing...';
                } else if (info.status === 'loading language traineddata') {
                    progressStatus.textContent = 'Loading language data...';
                } else if (info.status === 'initializing api') {
                    progressStatus.textContent = 'Preparing...';
                }
            }
        }).then(function (result) {
            var text = result.data.text.trim();
            resultText.value = text;
            updateStats(text);
            resultCard.classList.remove('hidden');
            progressCard.classList.add('hidden');
            extractBtn.disabled = false;
        }).catch(function (err) {
            console.error('OCR Error:', err);
            progressStatus.textContent = 'Error: ' + (err.message || 'OCR failed');
            progressPercent.textContent = '';
            extractBtn.disabled = false;
        });
    });

    // ===== Stats =====
    function updateStats(text) {
        if (!text) {
            charCount.textContent = '0 characters';
            wordCount.textContent = '0 words';
            lineCount.textContent = '0 lines';
            return;
        }
        charCount.textContent = text.length + ' characters';
        var words = text.split(/\s+/).filter(function (w) { return w.length > 0; });
        wordCount.textContent = words.length + ' words';
        var lines = text.split('\n').filter(function (l) { return l.trim().length > 0; });
        lineCount.textContent = lines.length + ' lines';
    }

    // ===== Copy =====
    copyBtn.addEventListener('click', function () {
        var text = resultText.value;
        if (!text) return;

        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).then(function () {
                showToast('Copied to clipboard!');
            }).catch(function () {
                fallbackCopy(text);
            });
        } else {
            fallbackCopy(text);
        }
    });

    function fallbackCopy(text) {
        resultText.select();
        document.execCommand('copy');
        showToast('Copied to clipboard!');
    }

    // ===== Download =====
    downloadBtn.addEventListener('click', function () {
        var text = resultText.value;
        if (!text) return;

        var blob = new Blob([text], { type: 'text/plain' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'extracted-text.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    });

    // ===== Camera =====
    cameraBtn.addEventListener('click', function () {
        openCamera();
    });

    closeCameraBtn.addEventListener('click', function () {
        closeCamera();
    });

    captureBtn.addEventListener('click', function () {
        capturePhoto();
    });

    function openCamera() {
        cameraModal.classList.remove('hidden');
        navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
            .then(function (stream) {
                cameraStream = stream;
                cameraVideo.srcObject = stream;
            })
            .catch(function (err) {
                console.error('Camera error:', err);
                closeCamera();
                showToast('Camera access denied');
            });
    }

    function closeCamera() {
        cameraModal.classList.add('hidden');
        if (cameraStream) {
            cameraStream.getTracks().forEach(function (track) { track.stop(); });
            cameraStream = null;
        }
        cameraVideo.srcObject = null;
    }

    function capturePhoto() {
        cameraCanvas.width = cameraVideo.videoWidth;
        cameraCanvas.height = cameraVideo.videoHeight;
        var ctx = cameraCanvas.getContext('2d');
        ctx.drawImage(cameraVideo, 0, 0);
        currentImage = cameraCanvas.toDataURL('image/png');
        previewImg.src = currentImage;
        previewCard.classList.remove('hidden');
        resultCard.classList.add('hidden');
        progressCard.classList.add('hidden');
        closeCamera();
    }

    // ===== Toast =====
    function showToast(message) {
        toast.textContent = message;
        toast.classList.remove('hidden');
        setTimeout(function () {
            toast.classList.add('hidden');
        }, 2000);
    }

})();
