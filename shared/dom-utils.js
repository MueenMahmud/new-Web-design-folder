/**
 * Shared DOM utility helpers.
 *
 * byId(id)          – cached getElementById wrapper
 * qs(scope, sel)    – querySelector scoped to a parent element
 */

var _domCache = {};

function byId(id) {
    if (!_domCache[id]) {
        _domCache[id] = document.getElementById(id);
    }
    return _domCache[id];
}

function qs(parent, selector) {
    return parent.querySelector(selector);
}
