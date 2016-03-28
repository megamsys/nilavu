import UserActivityStreamRoute from "nilavu/routes/user-activity-stream";
import UserAction from "nilavu/models/user-action";

export default UserActivityStreamRoute.extend({
  userActionType: UserAction.TYPES["mentions"]
});
