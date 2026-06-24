// Amer Kota - Voice Translation App
// Bengali -> Korean / English

(function () {
    'use strict';

    // ===== DOM Elements =====
    const micBtn = document.getElementById('mic-btn');
    const micStatus = document.getElementById('mic-status');
    const pulseRing = document.getElementById('pulse-ring');
    const inputText = document.getElementById('input-text');
    const outputText = document.getElementById('output-text');
    const outputTitle = document.getElementById('output-title');
    const targetLangSelect = document.getElementById('target-lang');
    const speakBtn = document.getElementById('speak-btn');
    const clearBtn = document.getElementById('clear-btn');
    const clearHistoryBtn = document.getElementById('clear-history-btn');
    const historyList = document.getElementById('history-list');
    const romanizedContainer = document.getElementById('romanized-container');
    const romanizedText = document.getElementById('romanized-text');
    const unsupportedModal = document.getElementById('unsupported-modal');

    // ===== State =====
    var isListening = false;
    var recognition = null;
    var lastTranslation = '';
    var history = [];

    // ===== Language Config =====
    var LANG_CONFIG = {
        ko: { name: 'Korean', flag: '\uD83C\uDDF0\uD83C\uDDF7', title: '\uD83C\uDDF0\uD83C\uDDF7 Korean Translation', speechLang: 'ko-KR' },
        en: { name: 'English', flag: '\uD83C\uDDEC\uD83C\uDDE7', title: '\uD83C\uDDEC\uD83C\uDDE7 English Translation', speechLang: 'en-US' }
    };

    // ===== Check Browser Support =====
    function checkSupport() {
        var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            unsupportedModal.classList.remove('hidden');
            micBtn.disabled = true;
            micStatus.textContent = 'Not supported';
            return false;
        }
        return true;
    }

    // ===== Speech Recognition Setup =====
    function setupRecognition() {
        var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) return;

        recognition = new SpeechRecognition();
        recognition.lang = 'bn-BD';
        recognition.continuous = false;
        recognition.interimResults = true;
        recognition.maxAlternatives = 1;

        recognition.onstart = function () {
            isListening = true;
            micBtn.classList.add('listening');
            pulseRing.classList.remove('hidden');
            micStatus.textContent = 'Listening... Speak now';
            micStatus.classList.add('active');
            setInputText('');
        };

        recognition.onresult = function (event) {
            var transcript = '';
            var isFinal = false;
            for (var i = event.resultIndex; i < event.results.length; i++) {
                transcript += event.results[i][0].transcript;
                if (event.results[i].isFinal) {
                    isFinal = true;
                }
            }
            setInputText(transcript);
            if (isFinal) {
                translateText(transcript);
            }
        };

        recognition.onerror = function (event) {
            stopListening();
            if (event.error === 'no-speech') {
                micStatus.textContent = 'No speech detected. Try again.';
            } else if (event.error === 'not-allowed') {
                micStatus.textContent = 'Microphone access denied.';
            } else {
                micStatus.textContent = 'Error: ' + event.error;
            }
        };

        recognition.onend = function () {
            stopListening();
        };
    }

    function startListening() {
        if (!recognition) return;
        recognition.lang = 'bn-BD';
        try {
            recognition.start();
        } catch (e) {
            // Already started
        }
    }

    function stopListening() {
        isListening = false;
        micBtn.classList.remove('listening');
        pulseRing.classList.add('hidden');
        micStatus.classList.remove('active');
        if (micStatus.textContent === 'Listening... Speak now') {
            micStatus.textContent = 'Tap to speak';
        }
    }

    // ===== Translation =====
    function translateText(text) {
        if (!text || !text.trim()) return;

        var targetLang = targetLangSelect.value;
        var config = LANG_CONFIG[targetLang];
        outputTitle.textContent = config.title;

        setOutputText('Translating...');
        speakBtn.disabled = true;
        romanizedContainer.classList.add('hidden');

        // Use Google Translate free endpoint
        var url = 'https://translate.googleapis.com/translate_a/single'
            + '?client=gtx&sl=bn&tl=' + encodeURIComponent(targetLang)
            + '&dt=t&dt=rm&q=' + encodeURIComponent(text);

        fetch(url)
            .then(function (response) {
                if (!response.ok) throw new Error('Translation failed');
                return response.json();
            })
            .then(function (data) {
                var translated = '';
                var romanized = '';
                if (data && data[0]) {
                    for (var i = 0; i < data[0].length; i++) {
                        if (data[0][i][0]) translated += data[0][i][0];
                    }
                }
                // Romanized text (if available for Korean)
                if (data && data[0] && data[0][0] && data[0][0].length > 3 && data[0][0][3]) {
                    romanized = data[0][0][3];
                }

                lastTranslation = translated;
                setOutputText(translated || 'No translation available');
                speakBtn.disabled = !translated;

                if (romanized && targetLang === 'ko') {
                    romanizedText.textContent = romanized;
                    romanizedContainer.classList.remove('hidden');
                } else {
                    romanizedContainer.classList.add('hidden');
                }

                addToHistory(text, translated, targetLang);
            })
            .catch(function (err) {
                setOutputText('Translation error. Please try again.');
                console.error('Translation error:', err);
            });
    }

    // ===== Text-to-Speech =====
    function speakTranslation() {
        if (!lastTranslation) return;
        if (!window.speechSynthesis) return;

        window.speechSynthesis.cancel();

        var targetLang = targetLangSelect.value;
        var config = LANG_CONFIG[targetLang];
        var utterance = new SpeechSynthesisUtterance(lastTranslation);
        utterance.lang = config.speechLang;
        utterance.rate = 0.9;
        utterance.pitch = 1;

        window.speechSynthesis.speak(utterance);
    }

    // ===== History =====
    function addToHistory(source, target, lang) {
        var config = LANG_CONFIG[lang];
        var entry = {
            source: source,
            target: target,
            lang: lang,
            langName: config.name,
            flag: config.flag,
            time: new Date().toLocaleTimeString()
        };
        history.unshift(entry);
        if (history.length > 20) history.pop();
        renderHistory();
    }

    function renderHistory() {
        if (history.length === 0) {
            historyList.innerHTML = '<p class="placeholder">Your translations will appear here...</p>';
            return;
        }
        var html = '';
        for (var i = 0; i < history.length; i++) {
            var entry = history[i];
            html += '<div class="history-item">'
                + '<span class="history-source">' + escapeHtml(entry.source) + '</span>'
                + '<span class="history-target">' + entry.flag + ' ' + escapeHtml(entry.target) + '</span>'
                + '<span class="history-meta">' + escapeHtml(entry.langName) + ' &bull; ' + escapeHtml(entry.time) + '</span>'
                + '</div>';
        }
        historyList.innerHTML = html;
    }

    // ===== Helpers =====
    function setInputText(text) {
        if (text) {
            inputText.innerHTML = '<span style="font-family: var(--font-bn)">' + escapeHtml(text) + '</span>';
        } else {
            inputText.innerHTML = '<span class="placeholder">Tap the microphone and speak in Bengali...</span>';
        }
    }

    function setOutputText(text) {
        if (text && text !== 'Translation will appear here...') {
            outputText.innerHTML = escapeHtml(text);
        } else {
            outputText.innerHTML = '<span class="placeholder">Translation will appear here...</span>';
        }
    }

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function clearInput() {
        setInputText('');
        setOutputText('');
        lastTranslation = '';
        speakBtn.disabled = true;
        romanizedContainer.classList.add('hidden');
        micStatus.textContent = 'Tap to speak';
    }

    function clearHistory() {
        history = [];
        renderHistory();
    }

    // ===== Event Listeners =====
    micBtn.addEventListener('click', function () {
        if (isListening) {
            if (recognition) recognition.stop();
        } else {
            startListening();
        }
    });

    speakBtn.addEventListener('click', function () {
        speakTranslation();
    });

    clearBtn.addEventListener('click', clearInput);
    clearHistoryBtn.addEventListener('click', clearHistory);

    targetLangSelect.addEventListener('change', function () {
        var config = LANG_CONFIG[targetLangSelect.value];
        outputTitle.textContent = config.title;
        // Re-translate if there is input text
        var currentInput = inputText.textContent;
        if (currentInput && !currentInput.includes('Tap the microphone')) {
            translateText(currentInput);
        }
    });

    // ===== Init =====
    if (checkSupport()) {
        setupRecognition();
    }

})();
