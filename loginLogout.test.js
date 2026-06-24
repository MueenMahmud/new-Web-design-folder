/**
 * Unit tests for gtpjavascript logand out.js
 *
 * Covers: login, logout, showLoginForm, showLogoutButton, checkLoginStatus
 */

const fs = require('fs');
const path = require('path');

// Load the HTML fixture used by the JS module
const html = fs.readFileSync(
    path.resolve(__dirname, 'gtp javascripttest.html'),
    'utf8'
);

// Helper: reset the DOM and localStorage before each test, then require the module fresh
function setupDOM() {
    document.documentElement.innerHTML = html;
    localStorage.clear();
}

let mod;

beforeAll(() => {
    // The module reads `window` and `document` at require-time via jsdom
    setupDOM();
    mod = require('./gtpjavascript logand out.js');
});

beforeEach(() => {
    setupDOM();
    // Suppress alert() calls so they don't throw
    jest.spyOn(window, 'alert').mockImplementation(() => {});
});

afterEach(() => {
    jest.restoreAllMocks();
});

// ---------------------------------------------------------------------------
// USER_DATA
// ---------------------------------------------------------------------------
describe('USER_DATA', () => {
    it('should expose default credentials', () => {
        expect(mod.USER_DATA).toEqual({
            username: 'user',
            password: 'password'
        });
    });
});

// ---------------------------------------------------------------------------
// login()
// ---------------------------------------------------------------------------
describe('login()', () => {
    it('should alert success and store session when credentials are correct', () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';

        mod.login();

        expect(localStorage.getItem('loggedIn')).toBe('true');
        expect(window.alert).toHaveBeenCalledWith('Login successful');
    });

    it('should show logout button after successful login', () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';

        mod.login();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(false);
    });

    it('should alert error when username is wrong', () => {
        document.getElementById('username').value = 'wrong';
        document.getElementById('password').value = 'password';

        mod.login();

        expect(localStorage.getItem('loggedIn')).toBeNull();
        expect(window.alert).toHaveBeenCalledWith('Invalid username or password');
    });

    it('should alert error when password is wrong', () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'wrong';

        mod.login();

        expect(localStorage.getItem('loggedIn')).toBeNull();
        expect(window.alert).toHaveBeenCalledWith('Invalid username or password');
    });

    it('should alert error when both fields are empty', () => {
        document.getElementById('username').value = '';
        document.getElementById('password').value = '';

        mod.login();

        expect(localStorage.getItem('loggedIn')).toBeNull();
        expect(window.alert).toHaveBeenCalledWith('Invalid username or password');
    });
});

// ---------------------------------------------------------------------------
// logout()
// ---------------------------------------------------------------------------
describe('logout()', () => {
    it('should clear the session from localStorage', () => {
        localStorage.setItem('loggedIn', 'true');

        mod.logout();

        expect(localStorage.getItem('loggedIn')).toBeNull();
    });

    it('should alert the user about successful logout', () => {
        localStorage.setItem('loggedIn', 'true');

        mod.logout();

        expect(window.alert).toHaveBeenCalledWith('Logged out successfully');
    });

    it('should show the login form after logout', () => {
        localStorage.setItem('loggedIn', 'true');

        mod.logout();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(true);
    });

    it('should clear the username and password fields', () => {
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';
        localStorage.setItem('loggedIn', 'true');

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
        const loginBtn = document.getElementById('login-container').querySelector('button');
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

        const loginBtn = document.getElementById('login-container').querySelector('button');
        expect(loginBtn.style.display).toBe('none');
    });
});

// ---------------------------------------------------------------------------
// checkLoginStatus()
// ---------------------------------------------------------------------------
describe('checkLoginStatus()', () => {
    it('should show logout button when loggedIn is true in localStorage', () => {
        localStorage.setItem('loggedIn', 'true');

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
        localStorage.setItem('loggedIn', 'false');

        mod.checkLoginStatus();

        const logoutContainer = document.getElementById('logout-container');
        expect(logoutContainer.classList.contains('hidden')).toBe(true);
    });
});

// ---------------------------------------------------------------------------
// Integration-style: full login → logout cycle
// ---------------------------------------------------------------------------
describe('login → logout cycle', () => {
    it('should complete a full login then logout flow', () => {
        // Start logged out
        mod.checkLoginStatus();
        expect(localStorage.getItem('loggedIn')).toBeNull();

        // Login
        document.getElementById('username').value = 'user';
        document.getElementById('password').value = 'password';
        mod.login();
        expect(localStorage.getItem('loggedIn')).toBe('true');

        // Logout
        mod.logout();
        expect(localStorage.getItem('loggedIn')).toBeNull();

        // Verify form is reset
        expect(document.getElementById('username').value).toBe('');
        expect(document.getElementById('password').value).toBe('');
    });
});
