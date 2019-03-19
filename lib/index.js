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
        var tmpl = JSON.parse(el.getAttribute('data-tmpl'));

        $(el).data('hodf', new Hodataframe(tmpl, el));
    };

    input_binding.getValue = function (el) {
        return JSON.stringify($(el).data('hodf').getDataFrame());
    };

    input_binding.receiveMessage = function (el, data) {
        var hodf = $(el).data('hodf');

        if (data.hasOwnProperty('value')) {
            // Set a new value
            $(el).data('hodf', hodf.replace(data.value));
        }
    };

    input_binding.subscribe = function (el, callback) {
        var hot = $(el).data('hodf').hot;

        hot.addHook('afterChange', callback);
        hot.addHook('afterCreateRow', callback);
        hot.addHook('afterCreateCol', callback);
        hot.addHook('afterRemoveRow', callback);
        hot.addHook('afterRemoveCol', callback);
    };

    return input_binding;
}()));
