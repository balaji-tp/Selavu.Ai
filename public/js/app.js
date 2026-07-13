/**
 * Selavu.Ai — Client-side data layer using localStorage
 * Provides user auth, expense CRUD, and utility helpers.
 */
const SelavuDB = (() => {
  const USERS_KEY = 'selavu_users';
  const EXPENSES_KEY = 'selavu_expenses';
  const SESSION_KEY = 'selavu_current_user';

  // ── helpers ──────────────────────────────────────
  const _get = (key) => JSON.parse(localStorage.getItem(key) || '[]');
  const _set = (key, data) => localStorage.setItem(key, JSON.stringify(data));

  // ── Users ────────────────────────────────────────
  function getUsers() { return _get(USERS_KEY); }

  function addUser(username, email, password) {
    const users = getUsers();
    if (users.find(u => u.username === username)) return { ok: false, msg: 'Username already exists.' };
    users.push({ username, email, password });
    _set(USERS_KEY, users);
    return { ok: true };
  }

  function login(username, password) {
    const user = getUsers().find(u => u.username === username && u.password === password);
    if (!user) return false;
    sessionStorage.setItem(SESSION_KEY, username);
    return true;
  }

  function logout() {
    sessionStorage.removeItem(SESSION_KEY);
  }

  function getCurrentUser() {
    return sessionStorage.getItem(SESSION_KEY) || null;
  }

  // ── Expenses ─────────────────────────────────────
  function getExpenses(username) {
    return _get(EXPENSES_KEY).filter(e => e.uname === username);
  }

  function addExpense({ uname, amount, iname, qty, category, pdate }) {
    const expenses = _get(EXPENSES_KEY);
    expenses.push({ uname, amount: parseFloat(amount), iname, qty, category, pdate });
    _set(EXPENSES_KEY, expenses);
    return true;
  }

  return { getUsers, addUser, login, logout, getCurrentUser, getExpenses, addExpense };
})();

// ── Auth Guard ─────────────────────────────────────
const SelavuAuth = {
  requireLogin() {
    if (!SelavuDB.getCurrentUser()) {
      window.location.href = 'signin.html';
      return null;
    }
    return SelavuDB.getCurrentUser();
  }
};

// ── Currency Formatter (INR) ───────────────────────
function formatCurrency(value) {
  return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(value);
}
