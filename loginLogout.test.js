/**
 * Unit tests for gtpjavascript logand out.js
 *
 * Covers: sha256, sanitizeInput, login, logout, showLoginForm,
 *         showLogoutButton, checkLoginStatus
 */

const fs = require('fs');
const path = require('path');
const { TextEncoder } = require('util');

// Polyfill TextEncoder for jsdom
global.TextEncoder = TextEncoder;

// Load the HTML fixture used by the JS module
const html = fs.readFileSync(
    path.resolve(__dirname, 'gtp javascripttest.html'),
    'utf8'
);

// Helper: reset the DOM and sessionStorage before each test
function setupDOM() {
    document.documentElement.innerHTML = html;
    sessionStorage.clear();
}

// Polyfill crypto.subtle.digest for jsdom (which may lack SubtleCrypto).
// Must be set before requiring the module so sha256() can find it.
const cryptoNode = require('crypto');
const subtleMock = {
    digest: async function (algo, data) {
        var name = algo === 'SHA-256' ? 'sha256' : algo.toLowerCase().replace('-', '');
        var hash = cryptoNode.createHash(name);
        hash.update(Buffer.from(data));
        return hash.digest().buffer;
    }
};
if (!globalThis.crypto) {
    globalThis.crypto = { subtle: subtleMock };
} else if (!globalThis.crypto.subtle) {
    Object.defineProperty(globalThis.crypto, 'subtle', { value: subtleMock, configurable: true });
} else {
    Object.defineProperty(globalThis.crypto.subtle, 'digest', { value: subtleMock.digest, configurable: true });
}

let mod;

beforeAll(() => {
    setupDOM();
    mod = require('./gtpjavascript logand out.js');
});

beforeEach(() => {
    setupDOM();
    jest.spyOn(window, 'alert').mockImplementation(() => {});
});

afterEach(() => {
    jest.restoreAllMocks();
});

// ---------------------------------------------------------------------------
// sanitizeInput()
// ---------------------------------------------------------------------------
describe('sanitizeInput()', () => {
    it('should return the string unchanged when it has no special chars', () => {
        expect(mod.sanitizeInput('hello')).toBe('hello');
    });

    it('should strip dangerous characters', () => {
        expect(mod.sanitizeInput('<script>"alert"&\'x\'')).toBe('scriptalertx');
    });

    it('should return empty string for non-string input', () => {
        expect(mod.sanitizeInput(null)).toBe('');
        expect(mod.sanitizeInput(undefined)).toBe('');
        expect(mod.sanitizeInput(123)).toBe('');
    });
});

// ---------------------------------------------------------------------------
// sha256()
// ---------------------------------------------------------------------------
describe('sha256()', () => {
    it('should produce the correct SHA-256 hash for "user"', async () => {
        var hash = await mod.sha256('user');
        expect(hash).toBe('04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb');
    });

    it('should produce the correct SHA-256 hash for "password"', async () => {
        var hash = await mod.sha256('password');
        expect(hash).toBe('5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');
    });
});

// ---------------------------------------------------------------------------
// login()
// ---------------------------------------------------------------------------
describe('login()', () => {
    it('should alert success and store session when credentials are correct', async () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';

        await mod.login();

        expect(sessionStorage.getItem('loggedIn')).toBe('true');
        expect(window.alert).toHaveBeenCalledWith('Login successful');
    });

    it('should show logout button after successful login', async () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';

        await mod.login();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(false);
    });

    it('should alert error when username is wrong', async () => {
        document.getElementById('username').value = 'wrong';
        document.getElementById('password').value = 'password';

        await mod.login();

        expect(sessionStorage.getItem('loggedIn')).toBeNull();
        expect(window.alert).toHaveBeenCalledWith('Invalid username or password');
    });

    it('should alert error when password is wrong', async () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'wrong';

        await mod.login();

        expect(sessionStorage.getItem('loggedIn')).toBeNull();
        expect(window.alert).toHaveBeenCalledWith('Invalid username or password');
    });

    it('should alert when both fields are empty', async () => {
        document.getElementById('username').value = '';
        document.getElementById('password').value = '';

        await mod.login();

        expect(sessionStorage.getItem('loggedIn')).toBeNull();
        expect(window.alert).toHaveBeenCalledWith('Please enter both username and password.');
    });
});

// ---------------------------------------------------------------------------
// logout()
// ---------------------------------------------------------------------------
describe('logout()', () => {
    it('should clear the session from sessionStorage', () => {
        sessionStorage.setItem('loggedIn', 'true');

        mod.logout();

        expect(sessionStorage.getItem('loggedIn')).toBeNull();
    });

    it('should alert the user about successful logout', () => {
        sessionStorage.setItem('loggedIn', 'true');

        mod.logout();

        expect(window.alert).toHaveBeenCalledWith('Logged out successfully');
    });

    it('should show the login form after logout', () => {
        sessionStorage.setItem('loggedIn', 'true');

        mod.logout();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(true);
    });

    it('should clear the username and password fields', () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';
        sessionStorage.setItem('loggedIn', 'true');

        mod.logout();

        expect(document.getElementById('username').value).toBe('');
        expect(document.getElementById('password').value).toBe('');
    });
});

// ---------------------------------------------------------------------------
// showLoginForm()
// ---------------------------------------------------------------------------
describe('showLoginForm()', () => {
    it('should hide the logout container', () => {
        const logoutContainer = document.getElementById('logout-container');
        logoutContainer.classList.remove('hidden');

        mod.showLoginForm();

        expect(logoutContainer.classList.contains('hidden')).toBe(true);
    });

    it('should clear the username input', () => {
        document.getElementById('username').value = 'some-user';

        mod.showLoginForm();

        expect(document.getElementById('username').value).toBe('');
    });

    it('should clear the password input', () => {
        document.getElementById('password').value = 'some-pass';

        mod.showLoginForm();

        expect(document.getElementById('password').value).toBe('');
    });

    it('should make the login button visible', () => {
        const loginBtn = document.getElementById('login-btn');
        loginBtn.style.display = 'none';

        mod.showLoginForm();

        expect(loginBtn.style.display).toBe('block');
    });
});

// ---------------------------------------------------------------------------
// showLogoutButton()
// ---------------------------------------------------------------------------
describe('showLogoutButton()', () => {
    it('should remove the hidden class from the logout container', () => {
        const logoutContainer = document.getElementById('logout-container');
        logoutContainer.classList.add('hidden');

        mod.showLogoutButton();

        expect(logoutContainer.classList.contains('hidden')).toBe(false);
    });

    it('should hide the login button', () => {
        mod.showLogoutButton();

        const loginBtn = document.getElementById('login-btn');
        expect(loginBtn.style.display).toBe('none');
    });
});

// ---------------------------------------------------------------------------
// checkLoginStatus()
// ---------------------------------------------------------------------------
describe('checkLoginStatus()', () => {
    it('should show logout button when loggedIn is true in sessionStorage', () => {
        sessionStorage.setItem('loggedIn', 'true');

        mod.checkLoginStatus();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(false);
    });

    it('should show login form when loggedIn is not set', () => {
        mod.checkLoginStatus();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(true);
    });

    it('should show login form when loggedIn is false', () => {
        sessionStorage.setItem('loggedIn', 'false');

        mod.checkLoginStatus();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(true);
    });
});

// ---------------------------------------------------------------------------
// Integration-style: full login → logout cycle
// ---------------------------------------------------------------------------
describe('login → logout cycle', () => {
    it('should complete a full login then logout flow', async () => {
        // Start logged out
        mod.checkLoginStatus();
        expect(sessionStorage.getItem('loggedIn')).toBeNull();

        // Login
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';
        await mod.login();
        expect(sessionStorage.getItem('loggedIn')).toBe('true');

        // Logout
        mod.logout();
        expect(sessionStorage.getItem('loggedIn')).toBeNull();

        // Verify form is reset
        expect(document.getElementById('username').value).toBe('');
        expect(document.getElementById('password').value).toBe('');
    });
});
