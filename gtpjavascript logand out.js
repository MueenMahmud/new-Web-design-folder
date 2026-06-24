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

/**
 * Safely read from sessionStorage. Returns null if storage is unavailable.
 */
function safeGetItem(key) {
    try {
        return sessionStorage.getItem(key);
    } catch (e) {
        console.error('Failed to read from sessionStorage:', e.message);
        return null;
    }
}

/**
 * Safely write to sessionStorage. Returns false if storage is unavailable.
 */
function safeSetItem(key, value) {
    try {
        sessionStorage.setItem(key, value);
        return true;
    } catch (e) {
        console.error('Failed to write to sessionStorage:', e.message);
        return false;
    }
}

/**
 * Safely remove from sessionStorage. Returns false if storage is unavailable.
 */
function safeRemoveItem(key) {
    try {
        sessionStorage.removeItem(key);
        return true;
    } catch (e) {
        console.error('Failed to remove from sessionStorage:', e.message);
        return false;
    }
}

/**
 * Display an error message to the user via the in-page error element.
 * Falls back to alert() if the error element is not present.
 */
function showError(message) {
    var errorEl = document.getElementById('error-message');
    if (errorEl) {
        errorEl.textContent = message;
        errorEl.classList.remove('hidden');
    } else {
        alert(message);
    }
}

/**
 * Clear the in-page error message display.
 */
function clearError() {
    var errorEl = document.getElementById('error-message');
    if (errorEl) {
        errorEl.textContent = '';
        errorEl.classList.add('hidden');
    }
}

function sanitizeInput(input) {
    if (typeof input !== 'string') return '';
    return input.replace(/[<>"'&]/g, '');
}

async function login() {
    clearError();

    var usernameEl = document.getElementById('username');
    var passwordEl = document.getElementById('password');

    if (!usernameEl || !passwordEl) {
        showError('Error: Login form elements are missing from the page.');
        console.error('login() failed: could not find #username or #password elements.');
        return;
    }

    var username = sanitizeInput(usernameEl.value);
    var password = sanitizeInput(passwordEl.value);

    if (username.length === 0 || password.length === 0) {
        showError('Please enter both username and password.');
        return;
    }

    var usernameHash = await sha256(username);
    var passwordHash = await sha256(password);

    if (usernameHash === EXPECTED_USERNAME_HASH && passwordHash === EXPECTED_PASSWORD_HASH) {
        if (!safeSetItem('loggedIn', 'true')) {
            showError('Login succeeded but session could not be saved. You may be in private browsing mode.');
        }
        showLogoutButton();
        clearError();
        alert('Login successful');
    } else {
        showError('Invalid username or password.');
    }
}

function logout() {
    if (!safeRemoveItem('loggedIn')) {
        console.error('logout(): could not clear session from sessionStorage.');
    }
    showLoginForm();
    alert('Logged out successfully');
}

function showLoginForm() {
    var logoutContainer = document.getElementById('logout-container');
    var usernameInput = document.getElementById('username');
    var passwordInput = document.getElementById('password');
    var loginButton = document.getElementById('login-btn');

    if (logoutContainer) {
        logoutContainer.classList.add('hidden');
    } else {
        console.error('showLoginForm(): #logout-container not found.');
    }

    if (usernameInput) {
        usernameInput.value = '';
    }
    if (passwordInput) {
        passwordInput.value = '';
    }
    if (loginButton) {
        loginButton.style.display = 'block';
    } else {
        console.error('showLoginForm(): #login-btn not found.');
    }
}

function showLogoutButton() {
    var logoutContainer = document.getElementById('logout-container');
    var loginButton = document.getElementById('login-btn');

    if (logoutContainer) {
        logoutContainer.classList.remove('hidden');
    } else {
        console.error('showLogoutButton(): #logout-container not found.');
    }

    if (loginButton) {
        loginButton.style.display = 'none';
    } else {
        console.error('showLogoutButton(): #login-btn not found.');
    }
}

function checkLoginStatus() {
    var loggedIn = safeGetItem('loggedIn');
    if (loggedIn === 'true') {
        showLogoutButton();
    } else {
        showLoginForm();
    }
}

if (typeof window !== 'undefined') {
    window.onload = function () {
        try {
            var loginBtn = document.getElementById('login-btn');
            var logoutBtn = document.getElementById('logout-btn');

            if (loginBtn) {
                loginBtn.addEventListener('click', login);
            } else {
                console.error('Initialization: #login-btn not found.');
            }

            if (logoutBtn) {
                logoutBtn.addEventListener('click', logout);
            } else {
                console.error('Initialization: #logout-btn not found.');
            }

            checkLoginStatus();
        } catch (e) {
            console.error('Error during page initialization:', e.message);
        }
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
