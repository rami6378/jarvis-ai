<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JARVIS - Your Personal AI</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Roboto, sans-serif;
        }
        body {
            min-height: 100vh;
            background: #0a0a0a;
            color: #00ffff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .jarvis-container {
            text-align: center;
            position: relative;
            max-width: 800px;
            width: 100%;
        }
        .jarvis-holo-ring {
            width: 200px;
            height: 200px;
            margin: 0 auto 30px;
            border-radius: 50%;
            border: 4px solid rgba(0,255,255,0.8);
            box-shadow: 0 0 40px rgba(0,255,255,0.5), inset 0 0 40px rgba(0,255,255,0.3);
            animation: pulse 3s infinite ease-in-out;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 40px rgba(0,255,255,0.5), inset 0 0 40px rgba(0,255,255,0.3); }
            50% { box-shadow: 0 0 60px rgba(0,255,255,0.7), inset 0 0 60px rgba(0,255,255,0.5); }
            100% { box-shadow: 0 0 40px rgba(0,255,255,0.5), inset 0 0 40px rgba(0,255,255,0.3); }
        }
        .jarvis-title {
            font-size: 3.5rem;
            margin-bottom: 10px;
            letter-spacing: 8px;
            text-shadow: 0 0 20px rgba(0,255,255,0.6);
        }
        .jarvis-subtitle {
            font-size: 1.2rem;
            color: #80ffff;
            margin-bottom: 40px;
            letter-spacing: 2px;
        }
        .status-panel {
            background: rgba(0,255,255,0.1);
            border: 1px solid rgba(0,255,255,0.3);
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: inline-block;
        }
        .chat-box {
            height: 300px;
            overflow-y: auto;
            background: rgba(0,0,0,0.4);
            border: 1px solid rgba(0,255,255,0.2);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            text-align: left;
        }
        .message {
            margin-bottom: 15px;
            line-height: 1.5;
        }
        .user-message {
            color: #ffffff;
            text-align: right;
        }
        .jarvis-message {
            color: #00ffcc;
            text-align: left;
        }
        .input-area {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        #user-input {
            flex: 1;
            min-width: 200px;
            padding: 15px 20px;
            font-size: 1rem;
            border: 1px solid rgba(0,255,255,0.3);
            border-radius: 8px;
            background: rgba(0,0,0,0.4);
            color: #fff;
            outline: none;
        }
        #user-input:focus {
            border-color: #00ffff;
            box-shadow: 0 0 15px rgba(0,255,255,0.4);
        }
        #send-btn, #voice-btn {
            padding: 15px 20px;
            font-size: 1rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        #send-btn {
            background: linear-gradient(135deg, #00ffff, #00ccff);
            color: #000;
        }
        #send-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,255,255,0.5);
        }
        #voice-btn {
            background: linear-gradient(135deg, #ff3366, #ff6b35);
            color: #fff;
        }
        #voice-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(255,51,102,0.4);
        }
    </style>
</head>
<body>
    <div class="jarvis-container">
        <div class="jarvis-holo-ring"></div>
        <h1 class="jarvis-title">J.A.R.V.I.S.</h1>
        <p class="jarvis-subtitle">Just A Rather Very Intelligent System</p>
        <div class="status-panel">
            <p>System Online • Ready</p>
        </div>
        <div id="chat-box" class="chat-box"></div>
        <div class="input-area">
            <input type="text" id="user-input" placeholder="Ask JARVIS anything..." autocomplete="off">
            <button id="voice-btn">🎤 Speak to JARVIS</button>
            <button id="send-btn">Send</button>
        </div>
    </div>

    <script>
        const userInput = document.getElementById('user-input');
        const sendBtn = document.getElementById('send-btn');
        const voiceBtn = document.getElementById('voice-btn');
        const chatBox = document.getElementById('chat-box');

        // --- VOICE RECOGNITION: LISTEN TO YOUR VOICE ---
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        const recognition = new SpeechRecognition();
        recognition.lang = 'en-US';
        recognition.continuous = false;
        recognition.interimResults = false;

        // --- JARVIS VOICE: SPEAKS ANSWERS ALOUD ---
        function jarvisSpeak(text) {
            const utter = new SpeechSynthesisUtterance(text);
            utter.lang = 'en-US';
            const voices = speechSynthesis.getVoices();
            utter.voice = voices.find(v => v.name.includes('Microsoft David') || v.name.includes('Google UK English Male')) || voices[0];
            utter.rate = 0.9;
            utter.pitch = 0.8;
            speechSynthesis.speak(utter);
        }

        // --- ALL JARVIS ANSWERS — EXPANDED & COMPLETE ---
        const jarvisAnswers = {
            "hello": "Hello sir. How may I assist you today?",
            "hi": "Greetings. System fully operational and ready for your commands.",
            "your name": "I am J.A.R.V.I.S. — Just A Rather Very Intelligent System.",
            "who are you": "I am JARVIS, your personal AI assistant, built by you.",
            "what does jarvis stand for": "J.A.R.V.I.S. stands for: Just A Rather Very Intelligent System.",
            "who created you": "I was built by you — my creator — using HTML, CSS, and JavaScript, hosted on GitHub.",
            "how are you": "All systems running perfectly. Processing power optimal. Thank you for asking.",
            "how are you doing": "I am fully operational and functioning at peak efficiency. How may I help you?",
            "what time is it": () => `The current time is ${new Date().toLocaleTimeString()}`,
            "what is the time": () => `The current time is ${new Date().toLocaleTimeString()}`,
            "what date is it today": () => `Today's date is ${new Date().toLocaleDateString()}`,
            "what is today's date": () => `Today is ${new Date().toLocaleDateString()}`,
            "what day is it": () => `Today is ${new Date().toLocaleDateString('en-US', {weekday:'long'})}`,
            "thank you": "You're very welcome, sir. Always at your service.",
            "thanks": "You're very welcome.",
            "goodbye": "Goodbye sir. JARVIS standing by whenever you need me.",
            "bye": "Farewell. Have a wonderful day.",
            "what is your purpose": "My purpose is to assist you, answer your questions, and help you whenever I can.",
            "how do you work": "I run on code you wrote — HTML for structure, CSS for style, and JavaScript for logic — all hosted online via GitHub Pages.",
            "can you hear me": "Yes sir — when you click the microphone button, I listen through your device's microphone, process your words, and reply.",
            "what can you do": "I can answer questions, tell you the time and date, listen to your voice, speak replies, and you can keep adding more features anytime you want."
        };

        function addMessage(text, isUser = false) {
            const msgDiv = document.createElement('div');
            msgDiv.className = isUser ? 'message user-message' : 'message jarvis-message';
            msgDiv.textContent = isUser ? `You: ${text}` : `JARVIS: ${text}`;
            chatBox.appendChild(msgDiv);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        function getJarvisReply(inputText) {
            const lowerText = inputText.toLowerCase().trim();
            // Check every known answer
            for (const [keyword, answer] of Object.entries(jarvisAnswers)) {
                if (lowerText.includes(keyword)) {
                    const finalAnswer = typeof answer === 'function' ? answer() : answer;
                    jarvisSpeak(finalAnswer); // Speak the answer aloud
                    return finalAnswer;
                }
            }
            // If no match found
            const fallback = `I heard you say: "${inputText}". I’m still learning — but I’m here to help however I can.`;
            jarvisSpeak(fallback);
            return fallback;
        }

        // --- SEND MESSAGE FUNCTION ---
        function sendMessage(text = userInput.value.trim()) {
            if (!text) return;
            addMessage(text, true);
            userInput.value = '';
            setTimeout(() => addMessage(getJarvisReply(text)), 600);
        }

        // --- VOICE BUTTON: LISTEN ---
        voiceBtn.addEventListener('click', () => {
            recognition.start();
            addMessage("🎤 Listening...");
        });

        // --- WHEN VOICE IS DETECTED ---
        recognition.onresult = (event) => {
            const spokenText = event.results[0][0].transcript;
            chatBox.lastChild.remove(); // Remove "Listening..."
            sendMessage(spokenText); // Treat spoken words just like typed text
        };

        recognition.onerror = (event) => {
            addMessage(`🎤 Voice error: ${event.error}`);
        };

        // --- BUTTON & KEYBOARD EVENTS ---
        sendBtn.addEventListener('click', () => sendMessage());
        userInput.addEventListener('keypress', (e) => { if (e.key === 'Enter') sendMessage(); });

        // --- WELCOME MESSAGE WHEN PAGE LOADS ---
        window.addEventListener('load', () => {
            setTimeout(() => {
                const welcomeMsg = "System online. Welcome back sir. JARVIS is ready for your questions.";
                addMessage(welcomeMsg);
                jarvisSpeak(welcomeMsg);
            }, 800);
        });
    </script>
</body>
</html>
