import { url } from 'nilavu/lib/computed';
import { on } from 'ember-addons/ember-computed-decorators';
import computed from 'ember-addons/ember-computed-decorators';
import RestModel from 'nilavu/models/rest';


const LaunchStatusTypes = {
    LAUNCHING: 'LAUNCHING',
    LAUNCHED: 'LAUNCHED',
    BOOTSTRAPPING: 'BOOTSTRAPPING',
    BOOTSTRAPPED: 'BOOTSTRAPPED',
    STATEUP: 'STATEUP',
    CHEFRUNNING: 'CHEFRUNNING',
    COOKBOOKSUCCESS: 'COOKBOOKSUCCESS',
    IPUPDATED: 'IPUPDATED',
    AUTHKEYSADDED: 'AUTHKEYSADDED',
    ROUTEADDED: 'ROUTEADDED'
}

const LaunchActionTypes = {
    STARTING: 'STARTING',
    STARTED: 'STARTED',
    STOPPING: 'STOPPING',
    STOPPED: 'STOPPED',
    RESTARTING: 'RESTARTING',
    RESTARTED: 'RESTARTED',
    REBOOTING: 'REBOOTING',
    REBOOTTED: 'REBOOTTED',
    DELETING: 'DELETING',
    DELETED: 'DELETED',
    SNAPSHOTTING: 'SNAPSHOTTING',
    SNAPSHOTTED: 'SNAPSHOTTED'
};

/** there could be more status that are considered successful */
const LaunchSuccessTypes = {
    RUNNING: 'RUNNING',
    STARTED: 'STARTED',
    STOPPED: 'STOPPED',
    SNAPSHOTTED: 'SNAPSHOTTED'
};

const LaunchErrorTypes = {
    ERROR: 'ERROR'
};

const LaunchStatus = RestModel.extend({

    @computed("event_type")
    successKey(action) {
        if (action != null) {
            var successArray = [];

            _.each(LaunchSuccessTypes, (k, v) => {
                successArray.push(k);
            });

            return successArray.indexOf(action) >= 0;
        }
        return false;
    },

    @computed("event_type")
    errorKey(action) {
        if (action != null) {
            var errorsArray = [];

            _.each(LaunchErrorTypes, (k, v) => {
                errorsArray.push(k);
            });

            return errorsArray.indexOf(action) >= 0;
        }

        return false;
    },

    @computed("event_type")
    statusKey(action) {
        if (action != null) {
            var statusArray = [];

            _.each(LaunchStatusTypes, (k, v) => {
                statusArray.push(k);
            });

            return statusArray.indexOf(action) >= 0;
        }

        return false;
    },

});

LaunchStatus.reopenClass({
    TYPES: LaunchStatusTypes,
    TYPES_ACTION: LaunchActionTypes,
    TYPES_SUCCESS: LaunchSuccessTypes,
    TYPES_ERROR: LaunchErrorTypes
});

export default LaunchStatus;
