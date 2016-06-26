import BufferedContent from 'nilavu/mixins/buffered-content';

export default Nilavu.Route.extend({

    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('marketplaces/show', {
            controller: 'marketplaces',
            outlet: 'list-container'
        });
    }


});
