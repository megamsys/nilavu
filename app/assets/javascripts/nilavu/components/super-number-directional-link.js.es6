
function mouseHoldStop() {
    Ember.run.cancel(this._lastRunLater);
}

export default Ember.Component.extend({
    _lastRunLater: null,
    isHoldingMouseDown: false,
    click: function() {
        return false;
    },
    runItLater: function() {
        this.sendAction();
        this._lastRunLater = Ember.run.later(this, 'runItLater', 100);
    },
    mouseDown: function() {
        this.runItLater();
    },
    dragStart: function() {
        return false;
    },
    mouseUp: mouseHoldStop,
    mouseLeave: mouseHoldStop
});
