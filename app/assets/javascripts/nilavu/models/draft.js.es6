const Draft = Nilavu.Model.extend();

Draft.reopenClass({
  get(key) {
    return Nilavu.ajax('/launchables.json', {
      data: { draft_key: key },
      dataType: 'json'
    });
  },

  getLocal(key, current) {
    // TODO: implement this
    return current;
  }

});

export default Draft;
