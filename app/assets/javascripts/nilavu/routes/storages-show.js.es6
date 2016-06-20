import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';
import Buckets from 'nilavu/models/buckets';
import BufferedContent from 'nilavu/mixins/buffered-content';
export default Nilavu.Route.extend({

    actions: {
        bucketCreate() {
            showModal('storageBucket', {
                title: 'bucket.title',
                smallTitle: true,
                titleCentered: true
            });
        },

        create() {
          alert("create");
            this._save();

        }
    },

    _save() {
      alert("_save");
      const self = this;
        Buckets.store().then(function() {
            alert("success");
        }).catch(function() {
              return self.replaceWith('/404');
        });
    },

    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('storages/show', {
            controller: 'storages',
            outlet: 'list-container'
        });
    }
});
