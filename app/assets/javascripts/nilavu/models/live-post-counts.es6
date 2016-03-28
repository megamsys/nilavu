const LivePostCounts = Nilavu.Model.extend({});

LivePostCounts.reopenClass({
  find() {
    return Nilavu.ajax("/about/live_post_counts.json").then(result => LivePostCounts.create(result));
  }
});

export default LivePostCounts;
