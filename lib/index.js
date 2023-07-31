"use strict";
/*jslint todo: true, regexp: true, browser: true */
/*global Shiny, $ */
var Hodataframe = require('hodf');

Shiny.inputBindings.register((function () {
    var input_binding = new Shiny.InputBinding();

    input_binding.find = function (scope) {
        return scope.querySelectorAll('.hodfr');
    };

    input_binding.initialize = function (el) {
        var tmpl = JSON.parse(el.getAttribute('data-tmpl')),
            initialValue = JSON.parse(el.getAttribute('data-initial-value') || []);

        $(el).data('change_callback', function () { return; });
        $(el).data('hodf', new Hodataframe(tmpl, el, initialValue));
        $(el).data('hodf').hot.addHook('afterChange', input_binding.on_change.bind(this, el));
        $(el).data('hodf').hot.addHook('afterCreateRow', input_binding.on_change.bind(this, el));
        $(el).data('hodf').hot.addHook('afterCreateCol', input_binding.on_change.bind(this, el));
        $(el).data('hodf').hot.addHook('afterRemoveRow', input_binding.on_change.bind(this, el));
        $(el).data('hodf').hot.addHook('afterRemoveCol', input_binding.on_change.bind(this, el));
    };

    input_binding.getType = function () {
        // Tell R to decode to data.frame (defined in hodfr.R)
        return "hodfr.jsonframe";
    };

    input_binding.getValue = function (el) {
        var out = $(el).data('hodf').getDataFrame();

        if (el.classList.contains('js-debug')) {
            console.debug("getValue", out);
        }
        return JSON.stringify(out);
    };

    input_binding.receiveMessage = function (el, data) {
        var hodf = $(el).data('hodf');

        if (data.hasOwnProperty('value')) {
            if (el.classList.contains('js-debug')) {
                console.debug("recvMessage", data.value);
            }
            // Set a new value
            $(el).data('hodf', hodf.replace(data.value));
            $(el).data('hodf').hot.addHook('afterChange', input_binding.on_change.bind(this, el));
            $(el).data('hodf').hot.addHook('afterCreateRow', input_binding.on_change.bind(this, el));
            $(el).data('hodf').hot.addHook('afterCreateCol', input_binding.on_change.bind(this, el));
            $(el).data('hodf').hot.addHook('afterRemoveRow', input_binding.on_change.bind(this, el));
            $(el).data('hodf').hot.addHook('afterRemoveCol', input_binding.on_change.bind(this, el));
            // Tell server the table got updated
            input_binding.on_change(el);
        }
    };

    input_binding.on_change = function (el) {
        $(el).data('change_callback')();
    };

    input_binding.subscribe = function (el, callback) {
        $(el).data('change_callback', callback);
    };

    input_binding.unsubscribe = function (el) {
        $(el).data('change_callback', function () { return; });
    };

    return input_binding;
}()));
