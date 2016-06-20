const Draft = Nilavu.Model.extend();

Draft.reopenClass({
  get(key) {
    return Nilavu.ajax('/launchables.json', {
      data: { draft_key: key },
      dataType: 'json'
    });
  },

  expandCooked() {
  return Nilavu.ajax("/launchables/" + this.get('id') + ".json").then(result => {
    this.setProperties({ cooked: result.cooked });
  });
  },

  rebake() {
    return Nilavu.ajax("/launchables/" + this.get('id') + ".json").then(result => {
      this.setProperties({ identifiers: result.identifiers });
    });
  },


  getLocal(key, current) {
    // TODO: implement this
    return current;
  }

});

export default Draft;
