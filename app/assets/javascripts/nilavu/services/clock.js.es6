import Ember from 'ember';

const { service, computed, run } = Ember;

export default Ember.Service.extend({

  hour: null,

  minute: null,

  second: null,

  nextTick: null,

  isTicking: computed.bool('nextTick'),

  init() {
    this._super();
    this.start();
  },

  start() {
    this.tick();
  },

  stop() {
    run.cancel(this.get('nextTick'));
    this.set('nextTick', null);
  },

  setTime() {
    let now = new Date();
    this.setProperties({
      second: now.getSeconds(),
      minute: now.getMinutes(),
      hour:   now.getHours()
    });
  },

  tick() {
		this.setTime();
  	this.set('nextTick', run.later(this, () => {
      this.tick ();
    }, 1000));
	},


  willDestroy() {
    this.stop();
  }
});
