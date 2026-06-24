// app.js

// Sample user data for demonstration (in a real application, this would be handled server-side)
const USER_DATA = {
    username: 'user',
    password: 'password'
};

// Function to handle login
function login() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (username === USER_DATA.username && password === USER_DATA.password) {
        // Save user session in localStorage
        localStorage.setItem('loggedIn', 'true');
        showLogoutButton();
        alert('Login successful');
    } else {
        alert('Invalid username or password');
    }
}

// Function to handle logout
function logout() {
    // Clear user session
    localStorage.removeItem('loggedIn');
    showLoginForm();
    alert('Logged out successfully');
}

// Function to show login form
function showLoginForm() {
    document.getElementById('login-container').querySelector('#logout-container').classList.add('hidden');
    document.getElementById('login-container').querySelector('#username').value = '';
    document.getElementById('login-container').querySelector('#password').value = '';
    document.getElementById('login-container').querySelector('button').style.display = 'block';
}

// Function to show logout button
function showLogoutButton() {
    document.getElementById('login-container').querySelector('#logout-container').classList.remove('hidden');
    document.getElementById('login-container').querySelector('button').style.display = 'none';
}

// Check login status on page load
function checkLoginStatus() {
    const loggedIn = localStorage.getItem('loggedIn');
    if (loggedIn === 'true') {
        showLogoutButton();
    } else {
        showLoginForm();
    }
}

// Run on page load
if (typeof window !== 'undefined') {
    window.onload = checkLoginStatus;
}

// Export for testing (Node.js / Jest)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        USER_DATA,
        login,
        logout,
        showLoginForm,
        showLogoutButton,
        checkLoginStatus
    };
}
