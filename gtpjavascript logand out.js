// app.js  (requires shared/dom-utils.js loaded first)

// IMPORTANT: In a production application, authentication must be handled
// server-side. Never store credentials in client-side JavaScript.
// This demo uses hashed comparison as a minimal safeguard, but real
// authentication requires a backend with secure password hashing (e.g. bcrypt).

// Minimal client-side hash using SubtleCrypto (SHA-256).
// This is NOT a substitute for server-side auth — it only prevents
// credentials from appearing as plaintext in source code.
async function sha256(message) {
    var msgBuffer = new TextEncoder().encode(message);
    var hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
    var hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(function (b) { return b.toString(16).padStart(2, '0'); }).join('');
}

// SHA-256 hashes of the demo credentials (username: "user", password: "password").
// In production, replace this with server-side authentication.
var EXPECTED_USERNAME_HASH = '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb';
var EXPECTED_PASSWORD_HASH = '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8';

function sanitizeInput(input) {
    if (typeof input !== 'string') return '';
    return input.replace(/[<>"'&]/g, '');
}

async function login() {
    var rawUsername = byId('username').value;
    var rawPassword = byId('password').value;

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
    byId('logout-container').classList.add('hidden');
    byId('username').value = '';
    byId('password').value = '';
    byId('login-btn').style.display = 'block';
}

function showLogoutButton() {
    byId('logout-container').classList.remove('hidden');
    byId('login-btn').style.display = 'none';
}

function checkLoginStatus() {
    if (sessionStorage.getItem('loggedIn') === 'true') {
        showLogoutButton();
    } else {
        showLoginForm();
    }
}

if (typeof window !== 'undefined') {
    window.onload = function () {
        byId('login-btn').addEventListener('click', login);
        byId('logout-btn').addEventListener('click', logout);
        checkLoginStatus();
    };
}

// Export for testing (Node.js / Jest)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        EXPECTED_USERNAME_HASH,
        EXPECTED_PASSWORD_HASH,
        sha256,
        sanitizeInput,
        login,
        logout,
        showLoginForm,
        showLogoutButton,
        checkLoginStatus
    };
}
