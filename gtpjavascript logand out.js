// app.js

// IMPORTANT: In a production application, authentication must be handled
// server-side. Never store credentials in client-side JavaScript.
// This demo uses hashed comparison as a minimal safeguard, but real
// authentication requires a backend with secure password hashing (e.g. bcrypt).

// Minimal client-side hash using SubtleCrypto (SHA-256).
// This is NOT a substitute for server-side auth — it only prevents
// credentials from appearing as plaintext in source code.
async function sha256(message) {
    const msgBuffer = new TextEncoder().encode(message);
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(function (b) { return b.toString(16).padStart(2, '0'); }).join('');
}

// SHA-256 hashes of the demo credentials (username: "user", password: "password").
// In production, replace this with server-side authentication.
const EXPECTED_USERNAME_HASH = '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb';
const EXPECTED_PASSWORD_HASH = '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8';

function sanitizeInput(input) {
    if (typeof input !== 'string') return '';
    return input.replace(/[<>"'&]/g, '');
}

async function login() {
    var rawUsername = document.getElementById('username').value;
    var rawPassword = document.getElementById('password').value;

    var username = sanitizeInput(rawUsername);
    var password = sanitizeInput(rawPassword);

    if (username.length === 0 || password.length === 0) {
        alert('Please enter both username and password.');
        return;
    }

    var usernameHash = await sha256(username);
    var passwordHash = await sha256(password);

    if (usernameHash === EXPECTED_USERNAME_HASH && passwordHash === EXPECTED_PASSWORD_HASH) {
        // Use sessionStorage instead of localStorage so the session
        // expires when the browser tab is closed.
        sessionStorage.setItem('loggedIn', 'true');
        showLogoutButton();
        alert('Login successful');
    } else {
        alert('Invalid username or password');
    }
}

function logout() {
    sessionStorage.removeItem('loggedIn');
    showLoginForm();
    alert('Logged out successfully');
}

function showLoginForm() {
    document.getElementById('login-container').querySelector('#logout-container').classList.add('hidden');
    document.getElementById('login-container').querySelector('#username').value = '';
    document.getElementById('login-container').querySelector('#password').value = '';
    document.getElementById('login-container').querySelector('button').style.display = 'block';
}

function showLogoutButton() {
    document.getElementById('login-container').querySelector('#logout-container').classList.remove('hidden');
    document.getElementById('login-container').querySelector('button').style.display = 'none';
}

function checkLoginStatus() {
    var loggedIn = sessionStorage.getItem('loggedIn');
    if (loggedIn === 'true') {
        showLogoutButton();
    } else {
        showLoginForm();
    }
}

window.onload = checkLoginStatus;
